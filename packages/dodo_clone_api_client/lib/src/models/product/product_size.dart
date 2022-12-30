part of 'product.dart';

class ProductSize {
  final String name;
  final String value;
  final bool active;
  final String description;
  final List<String>? crusts;

  const ProductSize({
    required this.name,
    required this.value,
    required this.active,
    required this.description,
    this.crusts,
  });
  static const empty = ProductSize(
    name: '',
    value: '',
    description: '',
    active: false,
  );

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      name: json['NAME'] ?? '',
      value: json['VALUE'] ?? '',
      description: json['DESCRIPTION'] ?? '',
      active: json['ACTIVE'] == 'Y' ? true : false,
      crusts: json['CRUST'],
    );
  }
}