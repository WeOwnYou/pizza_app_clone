part of 'product.dart';

///repo
class Topping extends Equatable {
  final int id;
  final num price;
  final String name;
  final String image;

  const Topping({
    required this.id,
    required this.price,
    required this.name,
    required this.image,
  });
  factory Topping.fromApiClient(dodo_clone_api_client.Topping topping) =>
      Topping(
        id: topping.index,
        price: topping.price,
        name: topping.name,
        image: topping.image,
      );

  Topping copyWith({
    int? id,
    num? price,
    String? name,
    String? image,
  }) {
    return Topping(
      id: id ?? this.id,
      price: price ?? this.price,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [id, price, name, image];
}
