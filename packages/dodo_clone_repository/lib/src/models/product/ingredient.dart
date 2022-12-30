part of 'product.dart';

class Ingredient extends Equatable {
  final int id;
  final String name;
  final bool modifiable;
  const Ingredient({
    required this.name,
    required this.modifiable,
    required this.id,
  });
  factory Ingredient.fromApiClient(dodo_clone_api_client.Ingredient ingredient) {
    return Ingredient(
      name:
      // index == 0
      //     ? ingredient.name[0].toUpperCase() + ingredient.name.substring(1)
      //     :
      ingredient.name.toLowerCase(),
      modifiable: ingredient.modifiable,
      id: ingredient.id,
    );
  }

  Ingredient copyWith({
    int? id,
    String? name,
    bool? modifiable,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      modifiable: modifiable ?? this.modifiable,
    );
  }

  @override
  List<Object?> get props => [id, name, modifiable];
}
