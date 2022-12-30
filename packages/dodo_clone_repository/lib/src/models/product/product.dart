import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    as dodo_clone_api_client;

part 'offer.dart';
part 'properties.dart';
part 'energy_value.dart';
part 'product_size.dart';
part 'ingredient.dart';
part 'topping.dart';
part 'crust.dart';

class Product extends Equatable {
  final int sectionId;
  final int id;
  final bool restaurantAvailable;
  final Map<int, bool>? restaurantsToBuy;
  final bool deliverAvailable;
  final String title;
  final String description;
  final List<int> ingredientsIDs;
  final List<int> toppingsIDs;
  final int selectedOfferId;
  final bool special;
  final String image;
  final bool? isHit;
  final List<Offer> offers;

  double get offerPrice => (offers
              .firstWhereOrNull((element) => element.id == selectedOfferId)
              ?.price ??
          0.0)
      .toDouble();

  const Product({
    required this.sectionId,
    required this.id,
    required this.restaurantAvailable,
    required this.description,
    this.restaurantsToBuy,
    required this.deliverAvailable,
    required this.title,
    required this.ingredientsIDs,
    required this.toppingsIDs,
    this.special = false,
    this.selectedOfferId = 0,
    this.isHit,
    required this.image,
    this.offers = const [],
  });

  bool get immutable => toppingsIDs.isEmpty && ingredientsIDs.isEmpty;

  List<String> get offersNames =>
      offers.map((e) => e.properties.size.value).toList();

  bool get available => offers.available;

  @override
  List<Object?> get props => [
        id,
        title,
        sectionId,
        ingredientsIDs,
        toppingsIDs,
        selectedOfferId,
        description,
      ];

  factory Product.fromApiClient(dodo_clone_api_client.Product product,
      {List<Topping>? toppings, List<Ingredient>? ingredients}) {
    String? description;
    if (product.ingredientIds != null && ingredients != null) {
      description = _formattedIngredients(
          allIngredients: ingredients, ingredientIds: product.ingredientIds!);
    }
    return Product(
      sectionId: product.categoryId,
      id: product.id,
      restaurantAvailable: product.restaurantAvailable,
      restaurantsToBuy: product.restaurantsToBuy,
      deliverAvailable: product.deliverAvailable,
      title: product.title,
      image: product.image,
      special: product.special ?? false,
      isHit: product.isHit,
      toppingsIDs: product.toppingsIds ?? [],
      offers: product.offers.map(Offer.fromApiClient).toList(),
      ingredientsIDs: product.ingredientIds ?? [],
      description: description ?? product.description,
      // TODO(fix): fix defaults Offer Id
      selectedOfferId: product.offers.first.id,
    );
  }

  static String _formattedIngredients(
      {required List<Ingredient> allIngredients,
      required List<int> ingredientIds}) {
    if (ingredientIds.isEmpty) return '';
    final productIngredients = ingredientIds
        .map((id) => allIngredients.firstWhere((element) => element.id == id));
    if (productIngredients.isEmpty) return '';
    var ingredientsFormatted = '';
    for (final ingredient in productIngredients) {
      ingredientsFormatted += '${ingredient.name}, ';
    }
    ingredientsFormatted =
        ingredientsFormatted.substring(0, ingredientsFormatted.length - 2);
    ingredientsFormatted =
        '${ingredientsFormatted[0].toUpperCase()}${ingredientsFormatted.substring(1).toLowerCase()}';
    return ingredientsFormatted;
  }

  String get offerDescription => selectedOffer.descriptionFormatted();

  // TODO(mes) FIX It can be NULL!!!!
  Offer get selectedOffer =>
      offers.firstWhereOrNull((element) => element.id == selectedOfferId) ??
      offers.first;

  Product byChangingCrust({
    required int crustIndex,
  }) {
    return Product(
      offers: [
        offers.first.copyWith(
          properties: offers.first.properties.copyWith(
            size: offers.first.properties.size.copyWith(
              activeCrustIndex: crustIndex,
            ),
          ),
        )
      ],
      sectionId: sectionId,
      id: id,
      restaurantAvailable: restaurantAvailable,
      restaurantsToBuy: restaurantsToBuy,
      deliverAvailable: deliverAvailable,
      title: title,
      ingredientsIDs: ingredientsIDs,
      toppingsIDs: toppingsIDs,
      selectedOfferId: selectedOfferId,
      special: special,
      image: image,
      isHit: isHit,
      description: description,
    );
  }

  Product copyWith({
    int? sectionId,
    int? id,
    bool? restaurantAvailable,
    Map<int, bool>? restaurantsToBuy,
    bool? deliverAvailable,
    String? title,
    String? description,
    List<int>? ingredientsIDs,
    List<int>? toppingsIDs,
    int? selectedOfferId,
    bool? special,
    String? image,
    bool? isHit,
    List<Offer>? offers,
  }) {
    return Product(
      sectionId: sectionId ?? this.sectionId,
      id: id ?? this.id,
      restaurantAvailable: restaurantAvailable ?? this.restaurantAvailable,
      restaurantsToBuy: restaurantsToBuy ?? this.restaurantsToBuy,
      deliverAvailable: deliverAvailable ?? this.deliverAvailable,
      title: title ?? this.title,
      ingredientsIDs: ingredientsIDs ?? this.ingredientsIDs,
      toppingsIDs: toppingsIDs ?? this.toppingsIDs,
      selectedOfferId: selectedOfferId ?? this.selectedOfferId,
      special: special ?? this.special,
      image: image ?? this.image,
      isHit: isHit ?? this.isHit,
      offers: offers ?? this.offers,
      description: description ?? this.description,
    );
  }

  @override
  bool? get stringify => null;
}
