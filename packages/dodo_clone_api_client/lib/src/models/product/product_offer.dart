part of 'product.dart';

class Offer {
  final int id;
  final int parentId;
  final String name;
  final ProductProperties properties;
  final String image;
  final num price;
  final num? oldPrice;
  final String? description;
  final String? additionalDescription;
  final bool available;
  final bool availableForBonuses;

  const Offer({
    required this.id,
    required this.parentId,
    required this.name,
    required this.properties,
    required this.image,
    this.description,
    this.additionalDescription,
    required this.price,
    this.oldPrice,
    required this.available,
    required this.availableForBonuses,
  });

  factory Offer.fromJson(
    Map<String, dynamic> json,
  ) {
    return Offer(
      id: json['ID'],
      parentId: json['PARENT_ID'],
      name: json['NAME'],
      properties: json['PROPERTIES'] == null
          ? ProductProperties.empty
          : ProductProperties.fromJson(json['PROPERTIES']),
      price: json['PRICE'],
      oldPrice: json['OLD_PRICE'],
      available: json['AVAILABLE'] == 'Y' ? true : false,
      availableForBonuses: json['AVAILABLE_FOR_BONUSES'] == 'Y' ? true : false,
      image: json['PICTURE'],
      description: json['DETAIL_TEXT'],
      additionalDescription: json['ADDITIONAL_DESCRIPTION'],
    );
  }
}
