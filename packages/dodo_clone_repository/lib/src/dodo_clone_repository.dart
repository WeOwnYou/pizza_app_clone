import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_storage_dodo_clone_api/local_storage_dodo_clone_api.dart';
import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    as dodo_clone_api_client;
import 'package:dodo_clone_repository/src/models/models.dart';

class DodoCloneRepository implements IDodoCloneRepository {
  /// default data
  int? _currentCityId;

  /// API Clients
  final dodo_clone_api_client.IDodoCloneApiClient _dodoCloneApiClient;
  final dodo_clone_api_client.IPersonApiClient _personApiClient;

  /// Local Storage
  final LocalStorageDodoCloneApi _localStorage;

  /// Main data
  List<Story> _cachedStories = [];
  List<Section> _sections = [];
  List<Product> _cachedProducts = [];
  final List<ShoppingCartItem> _cachedShoppingCart = [];
  List<Topping> _toppings = [];
  List<Ingredient> _ingredients = [];

  /// Controllers and listenable data
  final _shoppingCartController =
      StreamController<List<ShoppingCartItem>>.broadcast();
  late Box<LocalStorageShoppingCartItem> _cartItemProductsBox;

  @override
  List<Story> get cachedStories => _cachedStories;

  @override
  Future<List<Section>> get updatedSections async {
    await _loadSections();
    return _sections;
  }

  @override
  FutureOr<List<Section>> get cachedSections async =>
      _sections.isEmpty ? await updatedSections : _sections;

  @override
  List<Product> get cachedProducts => _cachedProducts;

  DodoCloneRepository(
      {required String url,
      dodo_clone_api_client.IDodoCloneApiClient? dodoCloneApiClient,
      dodo_clone_api_client.IPersonApiClient? personApiClient,
      LocalStorageDodoCloneApi? localStorage})
      : _dodoCloneApiClient = dodoCloneApiClient ??
            dodo_clone_api_client.DodoCloneApiClient(url: url),
        _personApiClient =
            personApiClient ?? dodo_clone_api_client.PersonApiClient(),
        _localStorage = localStorage ?? LocalStorageDodoCloneApi() {
    _initialize();
  }

  Future<void> _initialize() async {
    _currentCityId = await _localStorage.hiveProvider.getCityId();
    await _subscribe();
    await _loadShoppingCart();
  }

  @override
  Future<void> updateCityId(int cityId) async {
    if (_currentCityId == cityId) return;
    await _clearShoppingCart();
    _currentCityId = cityId;
  }

  Future<void> _subscribe() async {
    _cartItemProductsBox =
        await _localStorage.hiveProvider.openProductsCartBox();
    _cartItemProductsBox.listenable().addListener(_cartItemProductBoxListener);
  }

  Future<void> _cartItemProductBoxListener() async {
    _shoppingCartController.add(_cartItemProductsBox.values.map(
      (e) {
        return ShoppingCartItem.fromLocalStorage(
          e,
          _cachedProducts
              .firstWhereOrNull((element) => element.id == e.productId),
        );
      },
    ).toList());
    await _loadShoppingCart();
    _cachedShoppingCart;
    _cartItemProductsBox.compact();
  }

  /// [Story] data
  @override
  Future<List<Story>> updatedStories() async {
    await _loadStories();
    return _cachedStories;
  }

  @override
  void markStoryAsWatched(List<int> storiesIds) {
    storiesIds.map((e) {
      final index = _cachedStories.indexWhere((element) => element.id == e);
      _cachedStories[index] = _cachedStories[index].copyWith(isWatched: true);
    }).toList();
  }

  Future<void> _loadStories() async {
    if (_currentCityId == null) {
      _cachedStories.clear();
      return;
    }
    final storiesResponse = await _dodoCloneApiClient.stories(_currentCityId!);
    _cachedStories =
        List.from(storiesResponse.result.map(Story.fromApiClient).toList());
  }

  /// [Section] data
  Future<void> _loadSections() async {
    final allData = await _dodoCloneApiClient.sections();
    _sections = allData.result.map(Section.fromApiClient).toList();
  }

  /// [Product] data
  @override
  Future<List<Product>> updatedProducts() async {
    await _getAllProducts();
    return _cachedProducts;
  }

  Future<void> _getAllProducts() async {
    if (_currentCityId == null) {
      _cachedProducts.clear();
      return;
    }
    final allToppings = await toppings;
    final allIngredients = await ingredients;
    final allProducts = await _dodoCloneApiClient.products(_currentCityId!);
    _cachedProducts = List.from(
      allProducts.result.map(
        (e) => Product.fromApiClient(
          e,
          toppings: allToppings,
          ingredients: allIngredients,
        ),
      ),
    );
  }

  @override
  Future<List<LoyaltyOfferBlock>> loyaltyOffersBlock() async {
    final loyaltyOffersResponse =
        await _dodoCloneApiClient.loyaltyOffers(_currentCityId!);
    final allCityProducts = (await _dodoCloneApiClient.products(_currentCityId!)).result;
    final loyaltyOffersBlock = loyaltyOffersResponse.result
        .map(LoyaltyOfferBlock.fromApiClient)
        .toList();
    for (int i = 0; i < loyaltyOffersBlock.length; i++) {
      final offers = loyaltyOffersBlock[i].offers;
      for (int j = 0; j < offers.length; j++) {
        var offer = offers[j];
        if (allCityProducts.firstWhereOrNull((product) => product.id == offer.parentId) ==
            null) {
          offer = offer.copyWith(available: false);
          offers[j] = offer;
        }
      }
      loyaltyOffersBlock[i] = loyaltyOffersBlock[i].copyWith(offers: offers);
    }
    return loyaltyOffersBlock;
  }

  @override
  Future<Product> productDetails(int productId) async {
    final allToppings = await toppings;
    final allIngredients = await ingredients;
    final details = await _dodoCloneApiClient.productDetails(productId);
    return Product.fromApiClient(details,
        toppings: allToppings, ingredients: allIngredients);
  }

  /// [Topping] data
  @override
  FutureOr<List<Topping>> get toppings async {
    if (_toppings.isNotEmpty) return _toppings;
    final allToppings = await _dodoCloneApiClient.toppings();
    _toppings = List.from(allToppings.result.map(Topping.fromApiClient));
    return _toppings;
  }

  ///[Ingredient] data
  @override
  FutureOr<List<Ingredient>> get ingredients async {
    if (_ingredients.isNotEmpty) return _ingredients;
    final allIngredients = await _dodoCloneApiClient.ingredients();
    _ingredients =
        List.from(allIngredients.result.map(Ingredient.fromApiClient));
    return _ingredients;
  }

  /// [ShoppingCartItem] data
  @override
  Stream<List<ShoppingCartItem>> get shoppingCartStream async* {
    if (_cachedShoppingCart.isEmpty) await _loadShoppingCart();
    yield _cachedShoppingCart;
    yield* _shoppingCartController.stream;
  }

  @override
  Future<void> addProductsToCart({
    List<ShoppingCartItem>? productsToAdd,
    int? cartItemId,
  }) async {
    assert((productsToAdd != null) ^ (cartItemId != null),
        'Should be provided only 1 argument');
    assert(_currentCityId != null, 'Current city ID can\'t be null');
    if (cartItemId != null) {
      /// Передан ID ShoppingCartItem (нужно увеличить количество)
      final shoppingCartItemToIncrease = _cartItemProductsBox.get(cartItemId);
      if (shoppingCartItemToIncrease != null) {
        _cartItemProductsBox.put(
          cartItemId,
          shoppingCartItemToIncrease.copyWith(
              count: shoppingCartItemToIncrease.count + 1),
        );
      }
      return;
    } else {
      final resultList = <int, LocalStorageShoppingCartItem>{};

      /// Передан лист ShoppingCartItem или null
      if (productsToAdd == null || productsToAdd.isEmpty) {
        /// Непонятно откуда даже в теории может вернуться null или пустой лист, надо подумать и обработать
        return;
      } else {
        /// Передан не null и не пустой лист итемов
        /// Берем каждый отдельный элемент в пришедшем нам листе и прогоняем через существующую корзину
        /// чтобы найти совпадения, если они есть
        for (ShoppingCartItem item in productsToAdd) {
          final result = _cachedShoppingCart.firstWhereOrNull((element) {
            if (element.offerId == item.offerId &&
                element.description == item.description &&
                element.productType == item.productType) {
              // print(element.description);
              // print(item.description);
            } else {
              print(_cachedShoppingCart.map((e) => e.productId).toList());
              print(
                  'not found by item offerId: ${item.offerId} + description ${item.description}');
            }
            return element.offerId == item.offerId &&
                element.description == item.description &&
                element.productType == item.productType;
          });
          if (result == null) {
            print('new item offerId: ${item.offerId} + description ${item.description}');

            /// совпадений нет, создаем новый
            /// так как мы не последовательно добавляем товары- необходимо избежать повторения индексов, будь то
            /// корзина в хранилище или наша временная мапа для добавления в конце метода
            /// Берем максимальный индекс из имеющихся и инкрементим
            final generatedKey = max<int>(
                  (resultList.keys.lastOrNull ?? 0),
                  (_cartItemProductsBox.keys.lastOrNull ?? 0),
                ) +
                1;
            resultList.addAll({
              generatedKey: item
                  .copyWith(
                    id: generatedKey,
                  )
                  .toLocalStorage()
            });
          } else {
            /// есть совпадение, нужно увеличить имеющийся на [result.count] раз
            resultList.addAll({
              result.id: item
                  .copyWith(
                    id: result.id,
                    count: item.count + result.count,
                  )
                  .toLocalStorage(),
            });
          }
        }
      }
      await _cartItemProductsBox.putAll(resultList);
    }
  }
  /*
  }) async {
    ///Только один аругмент должен быть null
    assert((productsToAdd != null) ^ (cartItemId != null),
        'Should be provided only 1 argument');
    assert(_currentCityId != null, 'Current city ID can\'t be null');
    final shoppingCartItemsToAdd = <int, LocalStorageShoppingCartItem>{};
    final shoppingCartItemsInProcess = <LocalStorageShoppingCartItem>[];
    if (cartItemId != null) {
      if (_cachedProducts.isEmpty) _getAllProducts();

      ///Передан существующий индекс продукта
      final localStorageProduct = _cachedShoppingCart
          .firstWhere((element) => element.cartItemId == cartItemId)
          .product
          .toLocalStorage();
      shoppingCartItemsInProcess.add(LocalStorageShoppingCartItem(
          id: cartItemId, product: localStorageProduct, count: 1));
    } else {
      ///Передан list итемов из menuDetails или menu или repeatOrder, элементы которого, могут совпасть с существующими итемами в корзине,
      /// и дать существующий индекс и существующий итем,
      /// или не совпасть, и стать новым итемом с новым индексом
      for (final item in productsToAdd!) {
        shoppingCartItemsInProcess.add(item.toLocalStorage());
      }
    }
    for (final item in shoppingCartItemsInProcess) {
      final cartItemId = await _generateCartItemId(item,
          tempItemsInCart: shoppingCartItemsToAdd);
      final itemAlreadyInCart = shoppingCartItemsToAdd.keys
              .contains(cartItemId) ||
          (_cachedShoppingCart
                  .indexWhere((element) => element.cartItemId == cartItemId)) !=
              -1;
      if (itemAlreadyInCart) {
        final shoppingCartData = _cartItemProductsBox.get(cartItemId);
        if (shoppingCartData == null) continue;
        shoppingCartItemsToAdd[cartItemId] = shoppingCartData.copyWith(
            count: shoppingCartData.count + item.count);
        final index = _cachedShoppingCart
            .indexWhere((element) => element.cartItemId == cartItemId);
        final newCount = _cachedShoppingCart[index].count + item.count;
        _cachedShoppingCart[index] = _cachedShoppingCart[index].copyWith(
          count: newCount,
        );
      } else {
        final shoppingCartItem = ShoppingCartItem(
          count: item.count,
          product: Product.fromLocalStorage(
              item.product,
              _cachedProducts
                  .firstWhere((element) => element.id == item.product.id)),
          cartItemId: cartItemId,
        );
        shoppingCartItemsToAdd[cartItemId] = shoppingCartItem.toLocalStorage();
        _cachedShoppingCart.add(shoppingCartItem);
      }
    }
    await _cartItemProductsBox.putAll(shoppingCartItemsToAdd);
    _cachedShoppingCart = List.from(_cachedShoppingCart);
  }

     */

  @override
  Future<void> decreaseShoppingCartItemsCount(int cartItemId) async {
    if (_cachedShoppingCart.isEmpty) return;

    var targetProduct = _cartItemProductsBox.get(cartItemId);
    if (targetProduct == null) return;
    targetProduct = targetProduct.copyWith(
      count: max(0, targetProduct.count - 1),
    );
    if (targetProduct.count > 0) {
      /// Уменьшить количество продукта
      await _cartItemProductsBox.put(cartItemId, targetProduct);
      final index =
          _cachedShoppingCart.indexWhere((element) => element.id == cartItemId);
      _cachedShoppingCart[index] = ShoppingCartItem.fromLocalStorage(
          targetProduct,
          _cachedProducts
              .firstWhere((element) => element.id == targetProduct?.productId));
    } else {
      /// Удалить продукт из корзины
      await _cartItemProductsBox.delete(cartItemId);
      await _cartItemProductsBox.compact();
      // final index =
      //     _cachedShoppingCart.indexWhere((element) => element.id == cartItemId);
      // _cachedShoppingCart.removeAt(index);
    }
  }

  @override
  Future<void> removeShoppingCartItemFromCart(int cartItemId) async {
    await _cartItemProductsBox.delete(cartItemId);
    await _cartItemProductsBox.compact();
    await _loadShoppingCart();
  }

  Future<void> _loadShoppingCart() async {
    _cartItemProductsBox =
        await _localStorage.hiveProvider.openProductsCartBox();
    // if (_cachedShoppingCart.isNotEmpty) {
    //   _cachedShoppingCart.map((e) async {
    //     !_cartItemProductsBox.containsKey(e.id);
    //     await _cartItemProductsBox.put(e.id, e.toLocalStorage());
    //   });
    // }
    if (_cachedProducts.isEmpty) await _getAllProducts();
    if (_cachedProducts.isEmpty) return;
    _cachedShoppingCart
      ..clear()
      ..addAll(_cartItemProductsBox.values
          .map((e) => ShoppingCartItem.fromLocalStorage(
              e,
              _cachedProducts
                  .firstWhereOrNull((element) => element.id == e.productId)))
          .toList());
  }

  // Future<int> _generateCartItemId(LocalStorageShoppingCartItem shoppingCartItem,
  //     {Map<int, LocalStorageShoppingCartItem>? tempItemsInCart}) async {
  //   ///Первый итем в корзине актуальной или временной
  //   if (_cartItemProductsBox.isEmpty && (tempItemsInCart?.isEmpty ?? true)) {
  //     return 0;
  //   } else {
  //     ///Существующий итем в актуальной корзине
  //     for (final cartItemInBox in (_cartItemProductsBox.values)) {
  //       if (cartItemInBox.product == shoppingCartItem.product) {
  //         return cartItemInBox.id;
  //       }
  //     }
  //     if (tempItemsInCart?.isNotEmpty ?? false) {
  //       ///Если итема в актуальной корзине нет - ищем во временной
  //       for (final cartItemInTemp in tempItemsInCart!.values) {
  //         if (cartItemInTemp.product == shoppingCartItem.product) {
  //           return cartItemInTemp.id;
  //         }
  //       }
  //     }
  //
  //     ///Формируем новый индекс исходя из последнего элемента корзины
  //     ///(если актуальная корзина пустая,то генерируется новый индекс,
  //     /// исходя из послднего элемента временной)
  //     return 1 +
  //         (_cartItemProductsBox.isEmpty
  //             ? (tempItemsInCart!.values).last.id
  //             : (_cartItemProductsBox.values).last.id);
  //   }
  // }

  @override
  Future<OrdersHistory> ordersHistory(String accessToken) async {
    // TODO(fix): need to provide real token!!!
    final allData = await _personApiClient.ordersHistory(accessToken);
    return OrdersHistory.fromApiClient(allData);
  }

  /// DEV methods
  // TODO(dev): DEV method only while developing

  Future<void> _clearShoppingCart() async {
    await _cartItemProductsBox.clear();
    _cachedShoppingCart.clear();
  }
}

abstract class IDodoCloneRepository {
  Future<void> updateCityId(int cityId);
  Future<List<Story>> updatedStories();
  List<Story> get cachedStories;
  void markStoryAsWatched(List<int> storiesIds);
  Future<List<Section>> get updatedSections;
  FutureOr<List<Section>> get cachedSections;
  Future<List<Product>> updatedProducts();
  Future<List<LoyaltyOfferBlock>> loyaltyOffersBlock();
  List<Product> get cachedProducts;
  Future<Product> productDetails(int productId);
  FutureOr<List<Topping>> get toppings;
  FutureOr<List<Ingredient>> get ingredients;
  // TODO(mb): may be can do it better [addProductToCart]...
  Stream<List<ShoppingCartItem>> get shoppingCartStream;
  Future<void> addProductsToCart(
      {List<ShoppingCartItem>? productsToAdd, int? cartItemId});
  Future<void> decreaseShoppingCartItemsCount(int cartItemId);
  Future<void> removeShoppingCartItemFromCart(int cartItemId);
  Future<OrdersHistory> ordersHistory(String accessToken);
  // TODO(DEV): only DEV methods!!! DELETE BEFORE RELEASE
  // Future<void> deleteCity();
}
