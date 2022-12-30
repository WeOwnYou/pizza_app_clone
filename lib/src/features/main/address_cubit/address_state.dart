import 'package:address_repository/address_repository.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

enum AddressStateStatus { initial, success, failure }

class AddressState extends Equatable {
  final City? selectedCity;
  final List<City> cities;
  final List<Address> deliveryAddresses;
  final List<Address> restaurantAddresses;
  final AddressStateStatus status;

  const AddressState({
    required this.selectedCity,
    required this.status,
    this.cities = const [],
    this.deliveryAddresses = const [],
    this.restaurantAddresses = const [],
  });

  Address? get selectedDeliveryAddress => deliveryAddresses.firstWhereOrNull((address) => address.selected);
  Address? get selectedRestaurantAddress => restaurantAddresses.firstWhereOrNull((address) => address.selected);

  static const AddressState empty =
      AddressState(selectedCity: null, status: AddressStateStatus.initial);

  AddressState copyWith({
    City? selectedCity,
    List<Address>? deliveryAddresses,
    List<Address>? restaurantAddresses,
    List<City>? cities,
    AddressStateStatus? status,
  }) {
    return AddressState(
      selectedCity: selectedCity ?? this.selectedCity,
      deliveryAddresses: deliveryAddresses ?? this.deliveryAddresses,
      restaurantAddresses: restaurantAddresses ?? this.restaurantAddresses,
      cities: cities ?? this.cities,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        selectedCity,
        selectedDeliveryAddress,
        deliveryAddresses,
        restaurantAddresses,
        selectedRestaurantAddress,
        cities,
      ];
}
