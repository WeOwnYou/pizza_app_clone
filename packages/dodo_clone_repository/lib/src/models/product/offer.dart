part of 'product.dart';

class Offer extends Equatable {
  final int id;
  final int parentId;
  final String name;
  final Properties properties;
  final String image;
  final String? description;
  final num price;
  final bool available;
  final bool availableForBonuses;

  @override
  List<Object?> get props =>
      [id, parentId, name, properties, image, price, available];

  const Offer({
    required this.id,
    required this.parentId,
    required this.name,
    required this.properties,
    required this.image,
    required this.price,
    required this.available,
    required this.availableForBonuses,
    this.description,
  });

  bool get isPizza => properties.size.crusts != null;

  factory Offer.fromApiClient(dodo_clone_api_client.Offer offer) => Offer(
        id: offer.id,
        parentId: offer.parentId,
        name: offer.name,
        properties: Properties.fromApiClient(offer.properties),
        description: offer.description,
        image: offer.image,
        price: offer.price,
        available: offer.available,
        availableForBonuses: offer.availableForBonuses,
      );

  String descriptionFormatted([int? crustIndex]) {
    final productSize = properties.size.value;
      String? additionalPizzaInfo;
      if (isPizza) {
        final size = properties.size;
        final pizzaDescription = '${properties.size.description}, ';
        final crustInfo = '${size
            .crusts![crustIndex ?? properties.size.activeCrustIndex!].value
            .toLowerCase()} тесто';
        additionalPizzaInfo = pizzaDescription + crustInfo;
      }
      return '$productSize${(additionalPizzaInfo == null) ? '' : ' $additionalPizzaInfo'}';
  }

  Offer copyWith({
    int? id,
    int? parentId,
    String? name,
    Properties? properties,
    String? image,
    num? price,
    bool? available,
    String? description,
    bool? availableForBonuses,
  }) {
    return Offer(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      properties: properties ?? this.properties,
      image: image ?? this.image,
      available: available ?? this.available,
      price: price ?? this.price,
      description: description ?? this.description,
      availableForBonuses: availableForBonuses ?? this.availableForBonuses,
    );
  }
}

extension AvailableCheck on List<Offer>{
  bool get available{
        for(final offer in this){
      if(offer.available) {
        return true;
      }
    }
    return false;
  }
}
