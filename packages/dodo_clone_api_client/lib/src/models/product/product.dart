part 'section.dart';
part 'product_offer.dart';
part 'product_properties.dart';
part 'energy_value.dart';
part 'product_size.dart';

class Product {
  final int categoryId;
  final int id;
  final bool restaurantAvailable;
  final Map<int, bool>? restaurantsToBuy;
  final bool deliverAvailable;
  final String title;
  final String description;
  final String image;
  final List<Offer> offers;
  final bool? special;
  final num price;
  final bool isHit;
  final List<int>? toppingsIds;
  final List<int>? ingredientIds;

  Product({
    required this.categoryId,
    required this.id,
    required this.restaurantAvailable,
    this.restaurantsToBuy,
    required this.deliverAvailable,
    required this.title,
    required this.description,
    required this.price,
    required this.isHit,
    required this.offers,
    required this.image,
    this.special,
    this.toppingsIds,
    this.ingredientIds,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      categoryId: json['CATEGORY_ID'],
      id: json['ID'],
      restaurantAvailable: (json['RESTAURANT_AVAILABLE'] as bool?) ?? false,
      restaurantsToBuy: (json['RESTAURANTS_TO_BUY'] as Map<int, bool>?),
      deliverAvailable: (json['DELIVER_AVAILABLE'] as bool?) ?? false,
      title: json['NAME'] as String,
      description: json['DETAIL_TEXT'] as String,
      image: json['PICTURE'] as String,
      offers: (json['OFFERS'] as List<Map<String, dynamic>>)
          .map(Offer.fromJson)
          .toList(),
      special: (json['SPECIAL'] as bool?) ?? false,
      price: json['PRICE'],
      isHit: true,
      ingredientIds: json['INGREDIENTS'],
      toppingsIds: json['TOPPING_LIST'],
    );
  }
}
