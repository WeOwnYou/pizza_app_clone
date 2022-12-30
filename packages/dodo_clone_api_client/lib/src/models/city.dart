import 'dart:convert';

Cities citiesFromJson(Map<String, dynamic> str) => Cities.fromJson(str);

String citiesToJson(Cities data) => json.encode(data.toJson());

class Cities {
  Cities({
    required this.error,
    required this.message,
    this.result = const [],
  });

  final bool error;
  final String message;
  final List<City> result;

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
    error: json["error"],
    message: json["message"],
    result: List<City>.from(json["result"].map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class City {
  City({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
