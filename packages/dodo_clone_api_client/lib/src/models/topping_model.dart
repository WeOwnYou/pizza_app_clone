Toppings toppingsFromJson(Map<String, dynamic> str) => Toppings.fromJson(str);

class Toppings {
  final bool error;
  final String message;
  final List<Topping> result;

  Toppings({
    required this.error,
    required this.message,
    this.result = const [],
  });

  factory Toppings.fromJson(Map<String, dynamic> json) => Toppings(
        error: json['error'],
        message: json['message'],
        result: List.from(
          (json['result'] as List<Map<String, dynamic>>).map(
            Topping.fromJson,
          ),
        ),
      );
}

class Topping {
  final int index;
  final num price;
  final String name;
  final String image;

  const Topping({
    required this.index,
    required this.price,
    required this.name,
    required this.image,
  });

  factory Topping.fromJson(Map<String, dynamic> json) => Topping(
        index: json['id'] as int,
        price: json['price'] as num,
        name: json['name'] as String,
        image: json['image'] as String,
      );
}
