part 'working_hours.dart';

Addresses addressesFromJson(Map<String, dynamic> str, AddressType type) =>
    Addresses.fromJson(str, type);

class Addresses {
  Addresses({
    required this.error,
    required this.message,
    this.result = const [],
  });

  final bool error;
  final String message;
  final List<Address> result;

  factory Addresses.fromJson(Map<String, dynamic> json, AddressType type) =>
      Addresses(
        error: json['error'],
        message: json['message'],
        // TODO(universal) : need to reformat factory 'fromJson'. Even constructor!!!
        result: List.from(
          (json['result'] as List<Map<String, dynamic>>).map(
              type == AddressType.deliver
                  ? Address.fromDeliveryJson
                  : Address.fromRestaurantJson),
        ),
      );
}

enum AddressType { restaurant, deliver }

class Address {
  final int id;
  final AddressType type;
  final String city;
  final String street;
  final String house;
  final String? phone;
  final AddressLocation? location;
  final bool selected;
  final WorkingHours? workingHours;
  final int? apartment;
  final int? entrance;
  final int? floor;
  final String? doorCode;
  final String? title;
  final String? comment;

  Address({
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
    this.title,
    this.comment,
  });

  factory Address.fromRestaurantJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      city: json['city'],
      street: json['street'],
      house: json['house'],
      phone: json['phone_number'],
      location: AddressLocation.fromJson(json['location']),
      workingHours: WorkingHours.fromJson(json['working_hours']),
      selected: json['selected'] ?? false,
      type: AddressType.restaurant,
    );
  }

  factory Address.fromDeliveryJson(Map<String, dynamic> json) {
    return Address(
      id: (json['id'] as int?) ?? -1,
      city: json['city'],
      street: json['street'],
      house: json['house'],
      apartment: json['apartment'],
      entrance: json['entrance'],
      floor: json['floor'],
      doorCode: json['doorCode'],
      title: json['title'],
      comment: json['commentary'],
      selected: json['selected'] ?? false,
      type: AddressType.deliver,
    );
  }

  @override
  String toString() {
    return '$city, $street, $house${apartment == null ? '' : ' ,$apartment'}${entrance == null ? '' : ' ,$entrance'}${floor == null ? '' : ' ,$floor'}';
  }
}

class AddressLocation {
  double lat;
  double lon;

  AddressLocation({required this.lat, required this.lon});

  factory AddressLocation.fromJson(Map<String, dynamic> json) {
    return AddressLocation(
      lon: double.parse(
        json['lon'],
      ),
      lat: double.parse(json['lat']),
    );
  }
}
