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
  factory EnergyValue.fromApiClient(dodo_clone_api_client.EnergyValue energyValue) {
    return EnergyValue(
      proteins: energyValue.proteins,
      fats: energyValue.fats,
      carbohydrates: energyValue.carbohydrates,
      calories: energyValue.calories,
    );
  }
}