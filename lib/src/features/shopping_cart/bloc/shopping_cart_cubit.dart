import 'dart:async';

import 'package:address_repository/address_repository.dart';
import 'package:dodo_clone/src/features/shopping_cart/bloc/shopping_cart_state.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart'
    hide OrderType;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:person_repository/person_repository.dart';

class ShoppingCartCubit extends Cubit<ShoppingCartState> {
  final IDodoCloneRepository _dodoCloneRepository;
  final PersonRepository _personRepository;
  final IAddressRepository _addressRepository;
  late final StreamSubscription<List<ShoppingCartItem>>
      _shoppingCartSubscription;
  late final StreamSubscription<OrderType> _orderTypeSubscription;

  ShoppingCartCubit({
    required IDodoCloneRepository dodoCloneRepository,
    required PersonRepository personRepository,
    required IAddressRepository addressRepository,
  })  : _dodoCloneRepository = dodoCloneRepository,
        _personRepository = personRepository,
        _addressRepository = addressRepository,
        super(ShoppingCartState.empty) {
    _init();
  }

  Future<void> _init() async {
    final toppings = await _dodoCloneRepository.toppings;
    final sauces = (await _dodoCloneRepository.updatedProducts())
        .where((element) => element.sectionId == 5)
        .toList();
    emit(
      state.copyWith(
        sauces: sauces,
        toppings: toppings,
        addressSelected: _personRepository.orderType == OrderType.restaurant
            ? _addressRepository.selectedRestaurantAddress
            : _addressRepository.selectedDeliveryAddress,
      ),
    );
    _subscribe();
  }

  void _subscribe() {
    _shoppingCartSubscription =
        _dodoCloneRepository.shoppingCartStream.listen((shoppingCartItemsList) {
      final status = shoppingCartItemsList.isEmpty
          ? ShoppingCartStateStatus.empty
          : ShoppingCartStateStatus.hasData;
      emit(
        state.copyWith(
          shoppingCartProducts: List.from(shoppingCartItemsList),
          status: status,
        ),
      );
    });
    _orderTypeSubscription =
        _personRepository.orderTypeStream.listen((orderType) {
      emit(
        state.copyWith(
          orderType: orderType,
          addressSelected: orderType == OrderType.restaurant
              ? _addressRepository.selectedRestaurantAddress
              : _addressRepository.selectedDeliveryAddress,
        ),
      );
    });
  }

  Future<void> deleteFromCart(int id) async {
    await _dodoCloneRepository.removeShoppingCartItemFromCart(id);
  }

  Future<bool> checkPromoCode(String promoCode) async {
    return false;
  }

  @override
  Future<void> close() {
    _shoppingCartSubscription.cancel();
    _orderTypeSubscription.cancel();
    return super.close();
  }
}
