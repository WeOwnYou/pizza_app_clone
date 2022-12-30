part of 'product_details_cubit.dart';

enum ProductDetailsStateStatus { initial, success, failure }

class ProductDetailsState extends Equatable {
  final int activeOfferIndex;
  final int? activeCrustIndex;
  final num finalPrice;
  final Product product;
  final List<Ingredient> ingredientsList;
  final List<Topping> toppingsList;
  final ProductDetailsStateStatus status;

  Offer get currentOffer => product.offers[activeOfferIndex];

  Crust? get currentCrust =>
      activeCrustIndex == null || currentOffer.properties.size.crusts == null
          ? null
          : currentOffer.properties.size.crusts![activeCrustIndex!];

  const ProductDetailsState({
    required this.status,
    this.activeOfferIndex = 0,
    this.activeCrustIndex,
    this.finalPrice = 0,
    required this.product,
    this.ingredientsList = const [],
    this.toppingsList = const [],
  });

  @override
  List<Object?> get props => [
        activeOfferIndex,
        activeCrustIndex,
        finalPrice,
        product,
        ingredientsList,
        toppingsList,
      ];

  ProductDetailsState copyWith({
    int? activeOfferIndex,
    num? finalPrice,
    Product? product,
    int? activeCrustIndex,
    List<Ingredient>? ingredients,
    List<Topping>? toppings,
    ProductDetailsStateStatus? status,
  }) {
    return ProductDetailsState(
      activeOfferIndex: activeOfferIndex ?? this.activeOfferIndex,
      finalPrice: finalPrice ?? this.finalPrice,
      product: product ?? this.product,
      ingredientsList: ingredients ?? ingredientsList,
      toppingsList: toppings ?? toppingsList,
      activeCrustIndex: activeCrustIndex ?? this.activeCrustIndex,
      status: status ?? this.status,
    );
  }
}
