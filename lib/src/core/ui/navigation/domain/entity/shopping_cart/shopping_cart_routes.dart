import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_names.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_paths.dart';
import 'package:dodo_clone/src/features/shopping_cart/ui/shopping_cart_view.dart';

const shoppingCartRoutes = AutoRoute<dynamic>(
  path: AppRoutePaths.shoppingCartPath,
  name: AppRouteNames.shoppingCartScreen,
  page: ShoppingCartView,
);
