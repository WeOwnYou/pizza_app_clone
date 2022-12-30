import 'dart:async';

import 'package:dodo_clone/src/features/main/bloc/main_bloc/main_state.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<MainState> {
  final IDodoCloneRepository _dodoCloneRepository;
  late final StreamSubscription<List<ShoppingCartItem>>
      _shoppingCartSubscription;

  MainCubit(this._dodoCloneRepository) : super(const MainState()) {
    _subscribe();
  }

  void _subscribe() {
    _shoppingCartSubscription =
        _dodoCloneRepository.shoppingCartStream.listen((shoppingCartItemsList) {
      _updateShoppingCartCounter(shoppingCartItemsList.productsCount + shoppingCartItemsList.saucesCount);
    });
  }

  void _updateShoppingCartCounter(int count) {
    emit(state.copyWith(shoppingCartLength: count));
  }

  @override
  Future<void> close() {
    _shoppingCartSubscription.cancel();
    return super.close();
  }
}
