import 'package:address_repository/address_repository.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/features/splash/bloc/splash_state.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  final IAddressRepository _addressRepository;
  SplashCubit(this._addressRepository) : super(SplashState.initial) {
    _init();
  }

  Future<void> _init() async {
    final city = await _addressRepository.cityStream.first;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AppRouter.instance().replace(MainRouter(city: city));
    });
  }
}
