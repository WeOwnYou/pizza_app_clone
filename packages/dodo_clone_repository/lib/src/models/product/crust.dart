part of 'product.dart';

class Crust extends Equatable {
  final String value;
  final bool selected;

  const Crust({
    required this.value,
    required this.selected,
  });

  factory Crust.fromApiClient(String crust) {
    return Crust(value: crust, selected: false);
  }

  Crust copyWith({
    String? value,
    bool? selected,
  }) {
    return Crust(
      value: value ?? this.value,
      selected: selected ?? this.selected,
    );
  }

  @override
  String toString() {
    return 'Crust{value: $value, selected: $selected}';
  }

  @override
  List<Object?> get props => [value, selected];
}