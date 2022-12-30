import 'package:address_repository/address_repository.dart';
import 'package:equatable/equatable.dart';

class AddAddressState extends Equatable {
  final List<String> addressMarkers;
  final Address address;
  final bool canSave;

  const AddAddressState({
    this.addressMarkers = const [],
    this.address = Address.empty,
    this.canSave = false,
  });

  @override
  List<Object?> get props => [addressMarkers, address, canSave];

  AddAddressState copyWith({
    List<String>? addressMarkers,
    Address? address,
    bool? canSave,
  }) {
    return AddAddressState(
      addressMarkers: addressMarkers ?? this.addressMarkers,
      address: address ?? this.address,
      canSave: canSave ?? this.canSave,
    );
  }
}
