import 'package:address_repository/address_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_images.dart';
import 'package:dodo_clone/src/features/splash/bloc/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashView extends StatelessWidget implements AutoRouteWrapper {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (context) => SplashCubit(
        // AddressRepository(url: Url.prodUrl)
        context.read<IAddressRepository>(),
      ),
      child: this,
      lazy: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            AppImages.splashImage,
          ),
        ),
      ),
      child: Center(
        child: Transform.scale(
          scale: 2,
          child: const CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
