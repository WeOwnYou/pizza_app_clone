import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/contacts/contacts_routes.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/menu/menu_routes.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/profile/profile_routes.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/entity/shopping_cart/shopping_cart_routes.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/features/main/ui/main_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const mainRoutes = CustomRoute<MaterialWithModalsPageRoute<dynamic>>(
  path: '/main',
  name: 'mainRouter',
  page: MainView,
  customRouteBuilder: modalsPageRoute,
  children: [
    menuRoutes,
    profileRoutes,
    contactsRoutes,
    shoppingCartRoutes,
  ],
  transitionsBuilder: TransitionsBuilders.fadeIn,
  guards: [CheckIfCitySelected],
);

class CheckIfCitySelected extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final args = resolver.route.args as MainRouterArgs?;
    final city = args?.city;
    final citySelected = city != null;
    if (citySelected) {
      resolver.next();
    } else {
      unawaited(router.push(SelectCityRoute()));
    }
  }
}
