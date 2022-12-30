Ingredients ingredientsFromJson(Map<String, dynamic> str) =>
    Ingredients.fromJson(str);

class Ingredients {
  final bool error;
  final String message;
  final List<Ingredient> result;

  const Ingredients({
    required this.error,
    required this.message,
    this.result = const [],
  });

  factory Ingredients.fromJson(Map<String, dynamic> json) => Ingredients(
        error: json['error'],
        message: json['message'],
        result: List.from(
          (json['result'] as List<Map<String, dynamic>>).map(
            Ingredient.fromJson,
          ),
        ),
      );
}

class Ingredient {
  final int id;
  final String name;
  final bool modifiable;

  const Ingredient({
    required this.name,
    required this.modifiable,
    required this.id,
  });
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['NAME'],
      modifiable: json['MODIFIABLE'] == true,
      id: json['ID'],
    );
  }
}
