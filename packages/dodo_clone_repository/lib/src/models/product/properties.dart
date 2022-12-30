part of 'product.dart';

class Properties extends Equatable{
  final ProductSize size;
  final EnergyValue energyValue;
  final int weight;
  const Properties({
    required this.size,
    required this.energyValue,
    required this.weight,
  });
  factory Properties.fromApiClient(
      dodo_clone_api_client.ProductProperties properties) {
    return Properties(
      size: ProductSize.fromApiClient(properties.size),
      energyValue: EnergyValue.fromApiClient(properties.energyValue),
      weight: properties.weight,
    );
  }


  @override
  List<Object?> get props => [size];

  Properties copyWith({
    ProductSize? size,
    EnergyValue? energyValue,
    int? weight,
  }) {
    return Properties(
      size: size ?? this.size,
      energyValue: energyValue ?? this.energyValue,
      weight: weight ?? this.weight,
    );
  }
}