import 'package:dodo_clone_repository/dodo_clone_repository.dart'
    as dodo_clone_repository;
import 'package:equatable/equatable.dart';

///view
class Topping extends Equatable {
  final int id;
  final num price;
  final String name;
  final String image;
  final bool selected;

  const Topping({
    required this.id,
    required this.price,
    required this.name,
    required this.image,
    required this.selected,
  });
  factory Topping.fromRepository(dodo_clone_repository.Topping topping) =>
      Topping(
        id: topping.id,
        price: topping.price,
        name: topping.name,
        image: topping.image,
        selected: false,
      );

  Topping copyWith({
    int? id,
    num? price,
    String? name,
    String? image,
    bool? selected,
  }) {
    return Topping(
      id: id ?? this.id,
      price: price ?? this.price,
      name: name ?? this.name,
      image: image ?? this.image,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
        id,
        price,
        name,
        image,
        selected,
      ];
}

extension FormattedToppings on List<Topping> {
  String get formatted {
    if (isEmpty) return '';
    final buffer = StringBuffer()..write('\n+ ');
    for (final element in this) {
      buffer.write('${element.name.toLowerCase()}, ');
    }
    final toppingString =
        buffer.toString().substring(0, buffer.toString().length - 2);
    return toppingString;
  }
}
