part of 'product.dart';

class ProductProperties {
  final ProductSize size;
  final EnergyValue energyValue;
  final int weight;

  const ProductProperties({
    required this.size,
    required this.energyValue,
    required this.weight,
  });
  factory ProductProperties.fromJson(Map<String, dynamic> json) {
    return ProductProperties(
      size: json['SIZE'] == null
          ? ProductSize.empty
          : ProductSize.fromJson(json['SIZE']),
      energyValue: json['ENERGY_VALUE'] == null
          ? EnergyValue.empty
          : EnergyValue.fromJson(json['ENERGY_VALUE']),
      weight: json['WEIGHT'] ?? 0,
    );
  }
  static const empty = ProductProperties(
    size: ProductSize.empty,
    energyValue: EnergyValue.empty,
    weight: 0,
  );
}