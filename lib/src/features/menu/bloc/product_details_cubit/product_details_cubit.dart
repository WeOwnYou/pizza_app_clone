import 'package:dodo_clone/src/features/menu/entity/properties.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart'
    hide Topping, Ingredient;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final IDodoCloneRepository _dodoCloneRepository;
  ProductDetailsCubit({
    required IDodoCloneRepository dodoCloneRepository,
    required Product product,
  })  : _dodoCloneRepository = dodoCloneRepository,
        super(
          ProductDetailsState(
            product: product,
            status: ProductDetailsStateStatus.initial,
          ),
        ) {
    _init();
  }

  Future<void> _init() async {
    final productDetails =
        await _dodoCloneRepository.productDetails(state.product.id);
    final allToppings = await _dodoCloneRepository.toppings;
    final allIngredients = await _dodoCloneRepository.ingredients;
    final availableToppings = productDetails.toppingsIDs
        .map<Topping>(
          (topping) => Topping.fromRepository(
            allToppings.firstWhere((element) => element.id == topping),
          ),
        )
        .toList();
    final availableIngredients = productDetails.ingredientsIDs
        .map<Ingredient>(
          (ingredient) => Ingredient.fromRepository(
            allIngredients.firstWhere((element) => element.id == ingredient),
          ),
        )
        .toList();
    return emit(
      state.copyWith(
        product: productDetails,
        finalPrice: productDetails.offers[state.activeOfferIndex].price,
        ingredients: availableIngredients,
        toppings: availableToppings,
        activeCrustIndex: productDetails.offers.length > 1 ? 0 : null,
        status: ProductDetailsStateStatus.success,
      ),
    );
  }

  void changeOffer(int index) {
    var price = state.finalPrice;
    final offers = List<Offer>.from(state.product.offers);
    final currentOffer = offers[state.activeOfferIndex];
    final nextOffer = offers[index];
    price -= currentOffer.price;
    price += nextOffer.price;
    return emit(
      state.copyWith(
        activeOfferIndex: index,
        activeCrustIndex: (nextOffer.properties.size.crusts!.length - 1 <
                state.activeCrustIndex!)
            ? 0
            : state.activeCrustIndex,
        finalPrice: price,
        product: state.product.copyWith(offers: offers),
      ),
    );
  }

  void changePizzaCrust(int crustIndex) {
    final currentOffer = state.currentOffer;
    final previousCrust =
        currentOffer.properties.size.crusts![state.activeCrustIndex!];
    final selectedCrust = currentOffer.properties.size.crusts![crustIndex];
    currentOffer.properties.size.crusts![crustIndex] =
        selectedCrust.copyWith(selected: true);
    currentOffer.properties.size.crusts![state.activeCrustIndex!] =
        previousCrust.copyWith(selected: false);
    return emit(state.copyWith(activeCrustIndex: crustIndex));
  }

  void updateToppingStatus(Topping topping) {
    final toppings = List<Topping>.from(state.toppingsList);
    final toppingIndex = toppings.indexOf(topping);
    var price = state.finalPrice;
    if (topping.selected) {
      price -= topping.price;
    } else {
      price += topping.price;
    }
    toppings[toppingIndex] = topping.copyWith(selected: !topping.selected);
    return emit(
      state.copyWith(
        toppings: toppings,
        finalPrice: price,
      ),
    );
  }

  void clearAllToppings() {
    var price = state.finalPrice;

    for (final topping in state.toppingsList) {
      if (topping.selected) {
        price -= topping.price;
      }
    }

    final disabledToppings =
        state.toppingsList.map((e) => e.copyWith(selected: false)).toList();
    return emit(
      state.copyWith(
        finalPrice: price,
        toppings: disabledToppings,
      ),
    );
  }

  void updateIngredients(List<Ingredient> ingredients) {
    return emit(state.copyWith(ingredients: ingredients));
  }

  Product addProductToCart() {
    if (state.activeCrustIndex != null) {}
    final productToAdd = state.product.copyWith(
      offers: [state.currentOffer],
      toppingsIDs: state.toppingsList
          .where((element) => element.selected)
          .map((e) => e.id)
          .toList(),
      ingredientsIDs: state.ingredientsList
          .where((element) => !element.selected)
          .map((e) => e.id)
          .toList(),
      selectedOfferId: state.product.offers[state.activeOfferIndex].id,
    );
    return productToAdd.byChangingCrust(
      crustIndex: state.activeCrustIndex ?? 0,
    );
  }

  void addAllIngredients() {
    final ingredients = List<Ingredient>.of(state.ingredientsList);
    for (var i = 0; i < ingredients.length; i++) {
      ingredients[i] = ingredients[i].copyWith(selected: true);
    }
    return emit(state.copyWith(ingredients: ingredients));
  }

  List<String> get availableCrusts {
    if (state.product.offers[state.activeOfferIndex].properties.size.crusts ==
            null ||
        state.product.offers[state.activeOfferIndex].properties.size.crusts!
            .isEmpty) return [];
    return state.product.offers[state.activeOfferIndex].properties.size.crusts!
        .map((e) => e.value)
        .toList();
  }
}
