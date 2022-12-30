// ignore_for_file: unused_import
import 'package:address_repository/address_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:dodo_clone/src/core/domain/entity/entity.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_names.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_paths.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/contacts/contacts_routes.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/location/location_routes.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/main/main_routes.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/menu/menu_routes.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/profile/profile_routes.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/shopping_cart/shopping_cart_routes.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/splash/splash_route.dart';
import 'package:dodo_clone/src/features/contacts/ui/contacts_export.dart';
import 'package:dodo_clone/src/features/location/ui/view/select_city_view.dart';
import 'package:dodo_clone/src/features/main/ui/main_export.dart';
import 'package:dodo_clone/src/features/menu/ui/menu_export.dart';
import 'package:dodo_clone/src/features/profile/ui/profile_export.dart';
import 'package:dodo_clone/src/features/profile/ui/view/single_order_view.dart';
import 'package:dodo_clone/src/features/shopping_cart/ui/shopping_cart_export.dart';
import 'package:dodo_clone/src/features/splash/ui/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'View,Route',
  routes: [
    splashRoute,
    mainRoutes,
    selectCityRoute,
    storyRoute,
  ],
)

// extend the generated private router
class AppRouter extends _$AppRouter {
  AppRouter({required super.checkIfCitySelected});
  static final AppRouter _router = AppRouter._();

  AppRouter._() : super(checkIfCitySelected: CheckIfCitySelected());

  /// Singleton instance of [AppRouter]
  factory AppRouter.instance() => _router;
}
