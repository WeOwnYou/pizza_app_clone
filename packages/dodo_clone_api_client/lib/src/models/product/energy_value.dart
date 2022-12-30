part of 'product.dart';

class EnergyValue {
  final num proteins;
  final num fats;
  final num carbohydrates;
  final num calories;

  const EnergyValue({
    required this.proteins,
    required this.fats,
    required this.carbohydrates,
    required this.calories,
  });
  static const empty = EnergyValue(
    proteins: 0,
    fats: 0,
    carbohydrates: 0,
    calories: 0,
  );
  factory EnergyValue.fromJson(Map<String, dynamic> json) {
    return EnergyValue(
      proteins: json['PROTEINS'],
      fats: json['FATS'],
      carbohydrates: json['CARBOHYDRATES'],
      calories: json['CALORIES'],
    );
  }
}