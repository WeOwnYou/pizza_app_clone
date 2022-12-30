import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_names.dart';
import 'package:dodo_clone/src/core/ui/navigation/domain/app_route_paths.dart';
import 'package:dodo_clone/src/features/profile/ui/view/delivery_address_details_view.dart';
import 'package:dodo_clone/src/features/profile/ui/view/delivery_addresses_view.dart';
import 'package:dodo_clone/src/features/profile/ui/view/profile_view.dart';
import 'package:dodo_clone/src/features/profile/ui/view/orders_history_view.dart';
import 'package:dodo_clone/src/features/profile/ui/view/single_order_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const profileRoutes = CustomRoute<dynamic>(
  path: AppRoutePaths.profilePath,
  name: AppRouteNames.profileScreen,
  page: EmptyRouterPage,
  customRouteBuilder: modalsPageRoute,
  children: [
    CustomRoute<dynamic>(
      name: 'ProfileRouter',
      initial: true,
      page: ProfileView,
      customRouteBuilder: modalsPageRoute,
    ),
    AutoRoute<MaterialWithModalsPageRoute>(
      path: AppRoutePaths.deliveryAddressesPath,
      name: AppRouteNames.deliveryAddressesScreen,
      page: DeliveryAddressesView,
    ),
    AutoRoute<MaterialWithModalsPageRoute>(
      path: AppRoutePaths.deliveryAddressDetailsPath,
      name: AppRouteNames.deliveryAddressDetailsScreen,
      page: DeliveryAddressDetailsView,
    ),
    AutoRoute<dynamic>(
      path: AppRoutePaths.ordersHistoryPath,
      name: AppRouteNames.ordersHistoryScreen,
      page: OrdersHistoryView,
    ),
    AutoRoute<MaterialWithModalsPageRoute>(
      path: AppRoutePaths.ordersHistoryDetailsPath,
      name: AppRouteNames.ordersHistoryDetailsScreen,
      page: SingleOrderView,
    ),
  ],
);

Route<T> modalsPageRoute<T>(
    BuildContext context,
    Widget child,
    CustomPage<T> page,
    ) {
  return MaterialWithModalsPageRoute(
    fullscreenDialog: page.fullscreenDialog,
    settings: page,
    builder: (_) => child,
  );
}
