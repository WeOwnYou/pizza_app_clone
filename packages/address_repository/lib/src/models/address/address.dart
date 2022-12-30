import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    as dodo_clone_api_client;

part 'working_hours.dart';

enum AddressType { restaurant, delivery }

class Address {
  final int id;
  final String city;
  final String street;
  final String house;
  final String? phone;
  final AddressLocation? location;
  final AddressType type;
  final bool selected;
  final WorkingHours? workingHours;
  final int? apartment;
  final int? entrance;
  final int? floor;
  final String? doorCode;
  final String? alias;
  final String? comment;

  const Address({
    required this.id,
    required this.city,
    required this.street,
    required this.house,
    this.phone,
    this.location,
    required this.selected,
    required this.type,
    this.workingHours,
    this.apartment,
    this.entrance,
    this.floor,
    this.doorCode,
    this.alias,
    this.comment,
  });

  static const Address empty = Address(
      id: -1,
      city: '',
      street: '',
      house: '',
      selected: true,
      type: AddressType.delivery,);

  factory Address.fromApiClient(dodo_clone_api_client.Address address) {
    final type = address.type == dodo_clone_api_client.AddressType.deliver
        ? AddressType.delivery
        : AddressType.restaurant;
    return Address(
      id: address.id,
      city: address.city,
      street: address.street,
      house: address.house,
      phone: address.phone,
      location: type == AddressType.restaurant && address.location != null
          ? AddressLocation.fromApiClient(address.location!)
          : null,
      selected: address.selected,
      type: type,
      apartment: address.apartment,
      entrance: address.entrance,
      floor: address.floor,
      doorCode: address.doorCode,
      alias: address.title,
      comment: address.comment,
      workingHours: address.workingHours == null
          ? null
          : WorkingHours.fromApiClient(address.workingHours!),
    );
  }

  dodo_clone_api_client.Address toApiClient() {
    final type = this.type == AddressType.delivery
        ? dodo_clone_api_client.AddressType.deliver
        : dodo_clone_api_client.AddressType.restaurant;
    return dodo_clone_api_client.Address(
      id: id,
      city: city,
      street: street,
      house: house,
      selected: selected,
      type: type,
    );
  }

  String propertyByIndex(int index) {
    switch (index) {
      case 0:
        return street;
      case 1:
        return house;
      case 2:
        return '${apartment ?? ''}';
      case 3:
        return '${entrance ?? ''}';
      case 4:
        return '${floor ?? ''}';
      case 5:
        return doorCode ?? '';
      case 6:
        return alias ?? '';
      case 7:
        return comment ?? '';
      default:
        return '';
    }
  }

  String get addressFormatted =>
      'улица $street, $house ${apartment == null ? '' : ', $apartment'}';

  String? get workingHoursFormatted => workingHours == null
      ? null
      : 'С ${workingHours!.startTime} до ${workingHours!.endTime}';

  @override
  String toString() {
    return 'Address{street: $street, house: $house, apartment: $apartment, entrance: $entrance, floor: $floor, doorCode: $doorCode, alias: $alias, comment: $comment}';
  }

  Address copyWith({
    int? id,
    String? city,
    String? street,
    String? house,
    String? phone,
    AddressLocation? location,
    AddressType? type,
    bool? selected,
    WorkingHours? workingHours,
    int? apartment,
    int? entrance,
    int? floor,
    String? doorCode,
    String? alias,
    String? comment,
  }) {
    return Address(
      id: id ?? this.id,
      city: city ?? this.city,
      street: street ?? this.street,
      house: house ?? this.house,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      type: type ?? this.type,
      selected: selected ?? this.selected,
      workingHours: workingHours ?? this.workingHours,
      apartment: apartment ?? this.apartment,
      entrance: entrance ?? this.entrance,
      floor: floor ?? this.floor,
      doorCode: doorCode ?? this.doorCode,
      alias: alias ?? this.alias,
      comment: comment ?? this.comment,
    );
  }
}

class AddressLocation {
  double lat;
  double lon;

  factory AddressLocation.fromApiClient(
    dodo_clone_api_client.AddressLocation location,
  ) {
    return AddressLocation(lat: location.lat, lon: location.lon);
  }

  AddressLocation({required this.lat, required this.lon});
}
