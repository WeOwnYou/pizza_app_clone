import 'package:dodo_clone/src/core/ui/utils/extensions/string_extensions.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart'
    as dodo_clone_repository;
import 'package:equatable/equatable.dart';

///view
class Ingredient extends Equatable {
  final int id;
  final String name;
  final bool modifiable;
  final bool selected;
  const Ingredient({
    required this.name,
    required this.modifiable,
    required this.id,
    required this.selected,
  });
  factory Ingredient.fromRepository(
    // int index,
    dodo_clone_repository.Ingredient ingredient,
  ) {
    return Ingredient(
      name: ingredient.name.toLowerCase(),
      modifiable: ingredient.modifiable,
      id: ingredient.id,
      selected: true,
    );
  }

  Ingredient copyWith({
    int? id,
    String? name,
    bool? modifiable,
    bool? selected,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      modifiable: modifiable ?? this.modifiable,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        modifiable,
        selected,
      ];
}

extension GetDescription on List<Ingredient> {
  String get ingredientsToString {
    var description = '';
    forEach((ingredient) {
      final ingredientText = (ingredient.name == first.name)
          ? ingredient.name.capitalize()
          : ingredient.name;
      description +=
          '${ingredient.selected ? ingredientText : ingredientText.stroked}, ';
    });
    if (description.isEmpty) return '';
    return description.substring(0, description.length - 2);
  }

  bool get isChanged {
    for (final ingredient in this) {
      if (!ingredient.selected) {
        return true;
      }
    }
    return false;
  }

  String get formatted {
    if (isEmpty) return '';
    var ingredientsFormatted = '\n- ';
    for (final ingredient in this) {
      // ignore: use_string_buffers
      ingredientsFormatted += '${ingredient.name}, ';
    }
    return ingredientsFormatted.substring(0, ingredientsFormatted.length - 2);
  }
}
