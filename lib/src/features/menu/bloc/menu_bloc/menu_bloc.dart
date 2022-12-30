import 'dart:async';

import 'package:address_repository/address_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:dodo_clone/src/features/menu/entity/properties.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart'
    hide OrderType, Ingredient, Topping;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:person_repository/person_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final IDodoCloneRepository _dodoCloneRepository;
  final PersonRepository _personRepository;
  final IAddressRepository _addressRepository;

  /// END FLUTTER dependencies
  late final StreamSubscription<City?> _citySubscription;
  late final StreamSubscription<OrderType> _orderTypeSubscription;

  MenuBloc({
    required IDodoCloneRepository dodoCloneRepository,
    required PersonRepository personRepository,
    required IAddressRepository addressRepository,
  })  : _dodoCloneRepository = dodoCloneRepository,
        _personRepository = personRepository,
        _addressRepository = addressRepository,
        super(
          MenuState.initial,
        ) {
    on<MenuInitializeEvent>(_initialize);
    on<MenuUpdateByCityEvent>(_updateByCity);
    on<MenuUpdateByAddressEvent>(_updateByAddress);
    on<MenuStoryWatchedEvent>(_onStoryWatched);
    on<MenuCategoryChangedEvent>(
      _onCategoryChanged,
      transformer: droppable(),
    );
    on<MenuEndScrolling>(_onMenuEndScrolling);
    on<MenuOrderTypeToggleEvent>(_onDeliverToggled);
    on<MenuAddProductToCartEvent>(
      _onAddProductToCart,
      transformer: concurrent(),
    );
    on<MenuEndScrollingAtProduct>(
      _endScrollingToProduct,
      transformer: sequential(),
    );
    on<MenuEndAnimatingProduct>(_endAnimatingProduct);
  }

  Future<void> _initialize(
    MenuInitializeEvent event,
    Emitter<MenuState> emit,
  ) async {
    if (event.city == null) return;
    if (_addressRepository.selectedCity == null) {
      await _addressRepository.changeCity(event.city!.id);
    }
    try {
      /// запуск экрана всегда правоцирует изменение/загрузку города
      /// initialize не произойдет, если город null
      /// (AppRouterGuard перекинет на выбор города)
      final updatedState =
          await _loadData(city: event.city!, orderType: state.orderType);

      /// Подписываемся на изменение города и типа доставки
      _subscribe();
      emit(updatedState);
    } on Object catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: MenuStateStatus.failure));
    }
  }

  Future<MenuState> _loadData({
    required City city,
    required OrderType orderType,
  }) async {
    await _dodoCloneRepository.updateCityId(city.id);

    /// получаем данные из репозитория, сортируем секции и товары по section_id
    final stories =
        List<Story>.from(await _dodoCloneRepository.updatedStories());
    final allProducts = await _dodoCloneRepository.updatedProducts();
    final sections = await _dodoCloneRepository.updatedSections
      ..sort((prev, next) => prev.id.compareTo(next.id));
    final specialProducts = orderType == OrderType.delivery
        ? allProducts
            .where((element) => element.special && element.deliverAvailable)
            .toList()
        : allProducts
            .where(
              (element) =>
                  element.special &&
                  element.restaurantAvailable &&
                  (element.restaurantsToBuy?[
                          _addressRepository.selectedRestaurantAddress?.id] ??
                      false),
            )
            .toList();
    final deliverProducts = allProducts
        .where((element) => element.deliverAvailable)
        .toList()
      ..sort((prev, next) => prev.sectionId.compareTo(next.sectionId));
    final restaurantProducts = allProducts
        .where(
          (element) =>
              element.restaurantAvailable &&
              (element.restaurantsToBuy?[
                      _addressRepository.selectedRestaurantAddress?.id] ??
                  false),
        )
        .toList()
      ..sort((prev, next) => prev.sectionId.compareTo(next.sectionId));

    /// Отсеиваем секции, в которых при указанном типе доставки нет товаров
    final filteredSections = Set<int>.from(
      (orderType == OrderType.delivery ? deliverProducts : restaurantProducts)
          .map<int>((e) => e.sectionId),
    ).toList();
    final updatedSections = filteredSections
        .map((e) => sections.firstWhere((element) => element.id == e))
        .toList();
    return state.copyWith(
      orderType: orderType,
      sections: updatedSections,
      deliverProducts: deliverProducts,
      restaurantProducts: restaurantProducts,
      specialProducts: specialProducts,
      status: MenuStateStatus.success,
      stories: stories,
    );
  }

  void _subscribe() {
    _citySubscription = _addressRepository.cityStream.listen((city) {
      if (city != null) {
        add(MenuUpdateByCityEvent(city));
      }
    });
    _orderTypeSubscription = _personRepository.orderTypeStream.listen((type) {
      // add(MenuUpdateByOrderTypeEvent(type));
      add(MenuUpdateByAddressEvent(type: type));
    });
  }

  Future<void> _updateByCity(
    MenuUpdateByCityEvent event,
    Emitter<MenuState> emit,
  ) async {
    final updatedState =
        await _loadData(city: event.city, orderType: OrderType.delivery);
    emit(updatedState);
  }

  Future<void> _updateByAddress(
    MenuUpdateByAddressEvent event,
    Emitter<MenuState> emit,
  ) async {
    if (_addressRepository.selectedCity == null) return;
    emit(state.copyWith(orderType: event.type));
    final updatedState = await _loadData(
      city: _addressRepository.selectedCity!,
      orderType: event.type ?? state.orderType,
    );
    emit(updatedState);
  }

  Future<void> _onCategoryChanged(
    MenuCategoryChangedEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(
      state.copyWith(
        sectionCurrentIndex: event.currentIndex,
        menuInAnimation: true,
      ),
    );
  }

  void _onMenuEndScrolling(
    MenuEndScrolling event,
    Emitter<MenuState> emit,
  ) {
    emit(state.copyWith(menuInAnimation: false));
  }

  Future<void> _onStoryWatched(
    MenuStoryWatchedEvent event,
    Emitter<MenuState> emit,
  ) async {
    _dodoCloneRepository.markStoryAsWatched(event.watchedStories);
    emit(
      state.copyWith(
        stories: List<Story>.from(_dodoCloneRepository.cachedStories),
      ),
    );
  }

  void _onDeliverToggled(
    MenuOrderTypeToggleEvent event,
    Emitter<MenuState> emit,
  ) {
    final orderType =
        event.index == 0 ? OrderType.delivery : OrderType.restaurant;
    _personRepository.changeOrderType(orderType);
  }

  Future<void> _onAddProductToCart(
    MenuAddProductToCartEvent event,
    Emitter<MenuState> emit,
  ) async {
    final products = state.orderType == OrderType.delivery
        ? state.deliverProducts
        : state.restaurantProducts;
    final index =
        products.indexWhere((element) => element.id == event.product.id);
    final allToppings = (await _dodoCloneRepository.toppings)
        .map<Topping>(Topping.fromRepository);
    final selectedToppings = event.product.toppingsIDs
        .map<Topping>(
          (e) => allToppings.firstWhere((element) => element.id == e),
        )
        .toList();

    final allIngredients = (await _dodoCloneRepository.ingredients)
        .map<Ingredient>(Ingredient.fromRepository);
    final selectedIngredients = event.product.ingredientsIDs
        .map<Ingredient>(
          (e) => allIngredients.firstWhere((element) => element.id == e),
        )
        .toList();
    final description =
        '${event.product.offerDescription}${selectedIngredients.formatted}${selectedToppings.formatted}';
    emit(
      state.copyWith(
        animatedProductIndex: index,
        needToAnimateProduct: true,
        needToScrollAtProduct: event.needToAnimate,
      ),
    );
    final toppingsPrice = selectedToppings.isNotEmpty
        ? selectedToppings
            .map((e) => e.price)
            .toList()
            .reduce((value, element) => value + element)
        : 0.0;
    final shoppingCartItemPrice = ((event.product.offers
                .firstWhereOrNull(
                  (element) => element.id == event.product.selectedOfferId,
                )
                ?.price
                .toDouble()) ??
            0.0) +
        toppingsPrice;
    await _dodoCloneRepository.addProductsToCart(
      productsToAdd: [
        ShoppingCartItem.fromProduct(
          count: 1,
          product: event.product.copyWith(
            description: description == ''
                ? event.product.offerDescription
                : description,
          ),
          price: shoppingCartItemPrice,
        )
      ],
    );
  }

  void _endScrollingToProduct(
    MenuEndScrollingAtProduct event,
    Emitter<MenuState> emit,
  ) =>
      emit(state.copyWith(needToScrollAtProduct: false));

  void _endAnimatingProduct(
    MenuEndAnimatingProduct event,
    Emitter<MenuState> emit,
  ) =>
      emit(state.copyWith(needToAnimateProduct: false));

  @override
  Future<void> close() {
    _citySubscription.cancel();
    _orderTypeSubscription.cancel();
    return super.close();
  }
}

/*
  Future<void> _updateByOrderType(
    MenuUpdateByOrderTypeEvent event,
    Emitter<MenuState> emit,
  ) async {
    final allSections = await _dodoCloneRepository.cachedSections;
    final updatedSpecialProducts = _dodoCloneRepository.cachedProducts
        .where(
          (element) => element.special && event.type == OrderType.delivery
              ? element.deliverAvailable
              : element.restaurantAvailable,
        )
        .toList();
    final deliver = event.type == OrderType.delivery;
    final sectionsId = Set<int>.from(
      (deliver ? state.deliverProducts : state.restaurantProducts)
          .map<int>((e) => e.sectionId),
    ).toList();
    final updatedSections = sectionsId
        .map((e) => allSections.firstWhere((element) => element.id == e))
        .toList();
    emit(
      state.copyWith(
        specialProducts: updatedSpecialProducts,
        sections: updatedSections,
        orderType: event.type,
      ),
    );
  }
 */
