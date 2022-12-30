import 'dart:async';

import 'package:address_repository/address_repository.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository _addressRepository;
  AddressCubit({
    required AddressRepository addressRepository,
  })  : _addressRepository = addressRepository,
        super(AddressState.empty) {
    _init();
  }

  Future<void> _init() async {
    /// Load Data from repositories
    _addressRepository.cityStream.listen(_updateAddressesByCity);
    if (_addressRepository.selectedCity != null) {
      await _updateAddressesByCity(_addressRepository.selectedCity);
    } else {
      emit(
        state.copyWith(
          cities: await _addressRepository.cities,
        ),
      );
    }
  }

  Future<void> changeCity(int cityId) async {
    await _addressRepository.changeCity(cityId);
  }

  Future<void> _updateAddressesByCity(City? city) async {
    if (city == null) return;
    await _addressRepository.updateAddresses();
    final deliveryAddresses =
        List<Address>.from(_addressRepository.deliveryAddresses);
    final restaurantAddresses =
        List<Address>.from(_addressRepository.restaurantAddresses);
    emit(
      state.copyWith(
        selectedCity: city,
        deliveryAddresses: deliveryAddresses,
        restaurantAddresses: restaurantAddresses,
      ),
    );
  }

  void changeSelectedAddress(Address address) {
    final isRestaurant = address.type == AddressType.restaurant;
    _addressRepository.changeSelectedAddress(address);
    emit(
      isRestaurant
          ? state.copyWith(
              restaurantAddresses:
                  List<Address>.from(_addressRepository.restaurantAddresses),
            )
          : state.copyWith(
              deliveryAddresses:
                  List<Address>.from(_addressRepository.deliveryAddresses),
            ),
    );
  }

  void updateAddresses(Address addressToSave) {
    // TODO(fix): need to provide real token
    _addressRepository.addAddress(addressToSave, 'token');
    final deliveryAddresses = _addressRepository.deliveryAddresses;
    emit(
      state.copyWith(
        deliveryAddresses: deliveryAddresses,
      ),
    );
  }

  void removeDeliveryAddress(Address address) {
    final deliveryAddresses = List<Address>.of(state.deliveryAddresses)
      ..remove(address);
    return emit(
      state.copyWith(deliveryAddresses: deliveryAddresses),
    );
  }
}
