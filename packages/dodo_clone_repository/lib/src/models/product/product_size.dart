part of 'product.dart';

class ProductSize extends Equatable {
  final String name;
  final bool active;
  final String value;
  final String description;
  final List<Crust>? crusts;
  final int? activeCrustIndex;

  const ProductSize({
    required this.name,
    required this.active,
    required this.value,
    required this.description,
    this.crusts,
    this.activeCrustIndex,
  });
  factory ProductSize.fromApiClient(dodo_clone_api_client.ProductSize size) {
    return ProductSize(
      name: size.name,
      active: size.active,
      value: size.value,
      description: size.description,
      crusts: size.crusts?.map(Crust.fromApiClient).toList(),
      activeCrustIndex: size.crusts != null ? 0 : null,
    );
  }

  @override
  List<Object?> get props => [
        name,
        active,
        value,
        description,
        crusts,
        activeCrustIndex,
      ];

  ProductSize copyWith({
    String? name,
    bool? active,
    String? value,
    String? description,
    List<Crust>? crusts,
    int? activeCrustIndex,
  }) {
    return ProductSize(
      name: name ?? this.name,
      active: active ?? this.active,
      value: value ?? this.value,
      description: description ?? this.description,
      crusts: crusts ?? this.crusts,
      activeCrustIndex: activeCrustIndex ?? this.activeCrustIndex,
    );
  }
}
