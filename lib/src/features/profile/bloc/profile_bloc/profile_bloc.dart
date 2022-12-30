import 'dart:async';

import 'package:address_repository/address_repository.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/string_extensions.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:person_repository/person_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final PersonRepository _personRepository;
  final IDodoCloneRepository _dodoCloneRepository;
  final IAddressRepository _addressRepository;
  ProfileBloc(
    this._personRepository,
    this._dodoCloneRepository,
    this._addressRepository,
    super.initialState,
  ) {
    on<ProfileLoadEvent>(_loadProfile);
    on<RepeatOrderEvent>(_repeatOrder);
    on<DeleteAccountEvent>(_deleteAccount);
    on<UpdateCoinsNumberEvent>(_updateCoins);
  }

  Future<void> _loadProfile(
    ProfileLoadEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final personData = await _personRepository.person;
    final ordersHistory =
        // TODO(fix): need to provide real token!!!
        await _dodoCloneRepository.ordersHistory('personData.id');
    final promotions = await _personRepository.promotions(personData.id)
      ..removeWhere(
        (element) =>
            element.expires.stringToDate.compareTo(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1,
              ),
            ) <
            0,
      );
    final missions = await _personRepository.missions(personData.id);
    emit(
      state.copyWith(
        person: personData,
        promotions: promotions,
        missions: missions,
        status: ProfileStateStatus.success,
        ordersHistory: ordersHistory,
      ),
    );
  }

  Future<void> _repeatOrder(
    RepeatOrderEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final orderItems = state.ordersHistory.orders
        .firstWhere((element) => element.id == event.orderId);
    await _dodoCloneRepository.addProductsToCart(
      productsToAdd: orderItems.items,
      // orderItems.items
      //     .map(
      //       (shoppingCartItem) => ShoppingCartItem.fromState(
      //         count: shoppingCartItem.count,
      //         product: state,
      //       ),
      //     )
      //     .toList(),
    );
    await AppRouter.instance().navigate(const ShoppingCartRoute());
  }

  Future<void> _deleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _addressRepository.deleteCity();
    unawaited(AppRouter.instance().replace(const SplashRoute()));
  }

  void _updateCoins(
    UpdateCoinsNumberEvent event,
    Emitter<ProfileState> emit,
  ) {
    return emit(
      state.copyWith(
        person: state.person.copyWith(dodoCoins: event.actualCoins),
      ),
    );
  }
}
