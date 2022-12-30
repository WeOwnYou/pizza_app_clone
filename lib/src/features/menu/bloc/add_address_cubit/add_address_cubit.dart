import 'package:address_repository/address_repository.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/features/menu/bloc/add_address_cubit/add_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _kTextFieldItems = <String>[
  'Улица',
  'Дом (корпус, строение)',
  'Квартира или офис',
  'Подъезд',
  'Этаж',
  'Код на двери',
  'Название адреса',
  'Комментарий к адресу',
];

class AddAddressCubit extends Cubit<AddAddressState> {
  final IAddressRepository _addressRepository;
  late List<String> updatedState;
  final City? _currentCity;
  AddAddressCubit(
    this._addressRepository,
    this._currentCity,
    super.initialState,
  );

  Future<void> initialize() async {
    updatedState = List.generate(
      _kTextFieldItems.length,
      (index) => '',
    );
    emit(state.copyWith(addressMarkers: _kTextFieldItems));
    await _addressRepository.updateAddresses();
  }

  void changeAddress(int index, String data) {
    updatedState[index] = data;
    if (updatedState[0].isNotEmpty && state.canSave == false) {
      emit(state.copyWith(canSave: true));
    } else if ((updatedState[0].isEmpty || updatedState[1].isEmpty) &&
        state.canSave == true) {
      emit(state.copyWith(canSave: false));
    }
  }

  Future<List<String>> updateStreet(String street) async {
    var suggestionList = <String>[];
    try {
      suggestionList = await _addressRepository.streetSuggestions(
        city: 'Тамбов',
        street: street,
      );
    } on AddressCompletionException {
      // TODO(mes): may be we can use it, but now... no idea
    }
    return suggestionList;
  }

  void saveAddress() {
    AppRouter.instance().pop(listToAddress());
  }

  Address listToAddress() {
    return Address(
      id: -1,
      // TODO(fix): may be not nullable????
      city: _currentCity?.name ?? '',
      street: updatedState[0],
      house: updatedState[1],
      apartment: int.tryParse(updatedState[2]),
      entrance: int.tryParse(updatedState[3]),
      floor: int.tryParse(updatedState[4]),
      doorCode: updatedState[5],
      alias: updatedState[6],
      comment: updatedState[7],
      type: AddressType.delivery,
      selected: true,
    );
  }
}
