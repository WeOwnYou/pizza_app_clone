// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.checkIfCitySelected,
  }) : super(navigatorKey);

  final CheckIfCitySelected checkIfCitySelected;

  @override
  final Map<String, PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return MaterialPageX<MaterialWithModalsPageRoute<dynamic>>(
        routeData: routeData,
        child: WrappedRoute(child: const SplashView()),
      );
    },
    MainRouter.name: (routeData) {
      final args = routeData.argsAs<MainRouterArgs>(
          orElse: () => const MainRouterArgs());
      return CustomPage<MaterialWithModalsPageRoute<dynamic>>(
        routeData: routeData,
        child: WrappedRoute(
            child: MainView(
          city: args.city,
          key: args.key,
        )),
        customRouteBuilder: modalsPageRoute,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SelectCityRoute.name: (routeData) {
      final args = routeData.argsAs<SelectCityRouteArgs>(
          orElse: () => const SelectCityRouteArgs());
      return MaterialPageX<MaterialWithModalsPageRoute<dynamic>>(
        routeData: routeData,
        child: WrappedRoute(
            child: SelectCityView(
          parentContext: args.parentContext,
          controller: args.controller,
          key: args.key,
        )),
      );
    },
    StoryRoute.name: (routeData) {
      final args = routeData.argsAs<StoryRouteArgs>();
      return CustomPage<List<int>?>(
        routeData: routeData,
        child: WrappedRoute(
            child: StoryView(
          args.initialStoryIndex,
          key: args.key,
        )),
        fullscreenDialog: true,
        transitionsBuilder: TransitionsBuilders.zoomIn,
        opaque: false,
        barrierDismissible: false,
      );
    },
    MenuRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const EmptyRouterPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const EmptyRouterPage(),
        customRouteBuilder: modalsPageRoute,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ContactsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const EmptyRouterPage(),
      );
    },
    ShoppingCartRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ShoppingCartView(),
      );
    },
    MenuRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MenuView(),
      );
    },
    SearchRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SearchView(),
      );
    },
    ProfileRouter.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileView(),
        customRouteBuilder: modalsPageRoute,
        opaque: true,
        barrierDismissible: false,
      );
    },
    DeliveryAddressesRoute.name: (routeData) {
      return MaterialPageX<MaterialWithModalsPageRoute<dynamic>>(
        routeData: routeData,
        child: const DeliveryAddressesView(),
      );
    },
    DeliveryAddressDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<DeliveryAddressDetailsRouteArgs>();
      return MaterialPageX<MaterialWithModalsPageRoute<dynamic>>(
        routeData: routeData,
        child: DeliveryAddressDetailsView(
          address: args.address,
          key: args.key,
        ),
      );
    },
    OrdersHistoryRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const OrdersHistoryView(),
      );
    },
    OrderDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OrderDetailsRouteArgs>(
          orElse: () =>
              OrderDetailsRouteArgs(orderId: pathParams.getInt('id')));
      return MaterialPageX<MaterialWithModalsPageRoute<dynamic>>(
        routeData: routeData,
        child: SingleOrderView(
          orderId: args.orderId,
          key: args.key,
        ),
      );
    },
    ContactsRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ContactsView(),
      );
    },
    LegalDocumentsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LegalDocumentsView(),
      );
    },
    AboutAppRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const AboutAppView(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: 'splash',
          fullMatch: true,
        ),
        RouteConfig(
          SplashRoute.name,
          path: 'splash',
        ),
        RouteConfig(
          MainRouter.name,
          path: '/main',
          guards: [checkIfCitySelected],
          children: [
            RouteConfig(
              MenuRoute.name,
              path: 'menu',
              parent: MainRouter.name,
              children: [
                RouteConfig(
                  MenuRouter.name,
                  path: '',
                  parent: MenuRoute.name,
                ),
                RouteConfig(
                  SearchRoute.name,
                  path: 'search',
                  parent: MenuRoute.name,
                ),
              ],
            ),
            RouteConfig(
              ProfileRoute.name,
              path: 'profile',
              parent: MainRouter.name,
              children: [
                RouteConfig(
                  ProfileRouter.name,
                  path: '',
                  parent: ProfileRoute.name,
                ),
                RouteConfig(
                  DeliveryAddressesRoute.name,
                  path: 'addresses',
                  parent: ProfileRoute.name,
                ),
                RouteConfig(
                  DeliveryAddressDetailsRoute.name,
                  path: 'addressDetails',
                  parent: ProfileRoute.name,
                ),
                RouteConfig(
                  OrdersHistoryRoute.name,
                  path: 'ordersHistory',
                  parent: ProfileRoute.name,
                ),
                RouteConfig(
                  OrderDetailsRoute.name,
                  path: 'orders_history/order/:id',
                  parent: ProfileRoute.name,
                ),
              ],
            ),
            RouteConfig(
              ContactsRoute.name,
              path: 'contacts',
              parent: MainRouter.name,
              children: [
                RouteConfig(
                  ContactsRouter.name,
                  path: '',
                  parent: ContactsRoute.name,
                ),
                RouteConfig(
                  LegalDocumentsRoute.name,
                  path: 'legal_documents',
                  parent: ContactsRoute.name,
                ),
                RouteConfig(
                  AboutAppRoute.name,
                  path: 'about_app',
                  parent: ContactsRoute.name,
                ),
              ],
            ),
            RouteConfig(
              ShoppingCartRoute.name,
              path: 'shoppingCart',
              parent: MainRouter.name,
            ),
          ],
        ),
        RouteConfig(
          SelectCityRoute.name,
          path: 'select_city',
        ),
        RouteConfig(
          StoryRoute.name,
          path: 'story',
        ),
      ];
}

/// generated route for
/// [SplashView]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: 'splash',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [MainView]
class MainRouter extends PageRouteInfo<MainRouterArgs> {
  MainRouter({
    City? city,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          MainRouter.name,
          path: '/main',
          args: MainRouterArgs(
            city: city,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'MainRouter';
}

class MainRouterArgs {
  const MainRouterArgs({
    this.city,
    this.key,
  });

  final City? city;

  final Key? key;

  @override
  String toString() {
    return 'MainRouterArgs{city: $city, key: $key}';
  }
}

/// generated route for
/// [SelectCityView]
class SelectCityRoute extends PageRouteInfo<SelectCityRouteArgs> {
  SelectCityRoute({
    BuildContext? parentContext,
    ScrollController? controller,
    Key? key,
  }) : super(
          SelectCityRoute.name,
          path: 'select_city',
          args: SelectCityRouteArgs(
            parentContext: parentContext,
            controller: controller,
            key: key,
          ),
        );

  static const String name = 'SelectCityRoute';
}

class SelectCityRouteArgs {
  const SelectCityRouteArgs({
    this.parentContext,
    this.controller,
    this.key,
  });

  final BuildContext? parentContext;

  final ScrollController? controller;

  final Key? key;

  @override
  String toString() {
    return 'SelectCityRouteArgs{parentContext: $parentContext, controller: $controller, key: $key}';
  }
}

/// generated route for
/// [StoryView]
class StoryRoute extends PageRouteInfo<StoryRouteArgs> {
  StoryRoute({
    required int initialStoryIndex,
    Key? key,
  }) : super(
          StoryRoute.name,
          path: 'story',
          args: StoryRouteArgs(
            initialStoryIndex: initialStoryIndex,
            key: key,
          ),
        );

  static const String name = 'StoryRoute';
}

class StoryRouteArgs {
  const StoryRouteArgs({
    required this.initialStoryIndex,
    this.key,
  });

  final int initialStoryIndex;

  final Key? key;

  @override
  String toString() {
    return 'StoryRouteArgs{initialStoryIndex: $initialStoryIndex, key: $key}';
  }
}

/// generated route for
/// [EmptyRouterPage]
class MenuRoute extends PageRouteInfo<void> {
  const MenuRoute({List<PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          path: 'menu',
          initialChildren: children,
        );

  static const String name = 'MenuRoute';
}

/// generated route for
/// [EmptyRouterPage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          path: 'profile',
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [EmptyRouterPage]
class ContactsRoute extends PageRouteInfo<void> {
  const ContactsRoute({List<PageRouteInfo>? children})
      : super(
          ContactsRoute.name,
          path: 'contacts',
          initialChildren: children,
        );

  static const String name = 'ContactsRoute';
}

/// generated route for
/// [ShoppingCartView]
class ShoppingCartRoute extends PageRouteInfo<void> {
  const ShoppingCartRoute()
      : super(
          ShoppingCartRoute.name,
          path: 'shoppingCart',
        );

  static const String name = 'ShoppingCartRoute';
}

/// generated route for
/// [MenuView]
class MenuRouter extends PageRouteInfo<void> {
  const MenuRouter()
      : super(
          MenuRouter.name,
          path: '',
        );

  static const String name = 'MenuRouter';
}

/// generated route for
/// [SearchView]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute()
      : super(
          SearchRoute.name,
          path: 'search',
        );

  static const String name = 'SearchRoute';
}

/// generated route for
/// [ProfileView]
class ProfileRouter extends PageRouteInfo<void> {
  const ProfileRouter()
      : super(
          ProfileRouter.name,
          path: '',
        );

  static const String name = 'ProfileRouter';
}

/// generated route for
/// [DeliveryAddressesView]
class DeliveryAddressesRoute extends PageRouteInfo<void> {
  const DeliveryAddressesRoute()
      : super(
          DeliveryAddressesRoute.name,
          path: 'addresses',
        );

  static const String name = 'DeliveryAddressesRoute';
}

/// generated route for
/// [DeliveryAddressDetailsView]
class DeliveryAddressDetailsRoute
    extends PageRouteInfo<DeliveryAddressDetailsRouteArgs> {
  DeliveryAddressDetailsRoute({
    required Address address,
    Key? key,
  }) : super(
          DeliveryAddressDetailsRoute.name,
          path: 'addressDetails',
          args: DeliveryAddressDetailsRouteArgs(
            address: address,
            key: key,
          ),
        );

  static const String name = 'DeliveryAddressDetailsRoute';
}

class DeliveryAddressDetailsRouteArgs {
  const DeliveryAddressDetailsRouteArgs({
    required this.address,
    this.key,
  });

  final Address address;

  final Key? key;

  @override
  String toString() {
    return 'DeliveryAddressDetailsRouteArgs{address: $address, key: $key}';
  }
}

/// generated route for
/// [OrdersHistoryView]
class OrdersHistoryRoute extends PageRouteInfo<void> {
  const OrdersHistoryRoute()
      : super(
          OrdersHistoryRoute.name,
          path: 'ordersHistory',
        );

  static const String name = 'OrdersHistoryRoute';
}

/// generated route for
/// [SingleOrderView]
class OrderDetailsRoute extends PageRouteInfo<OrderDetailsRouteArgs> {
  OrderDetailsRoute({
    required int orderId,
    Key? key,
  }) : super(
          OrderDetailsRoute.name,
          path: 'orders_history/order/:id',
          args: OrderDetailsRouteArgs(
            orderId: orderId,
            key: key,
          ),
          rawPathParams: {'id': orderId},
        );

  static const String name = 'OrderDetailsRoute';
}

class OrderDetailsRouteArgs {
  const OrderDetailsRouteArgs({
    required this.orderId,
    this.key,
  });

  final int orderId;

  final Key? key;

  @override
  String toString() {
    return 'OrderDetailsRouteArgs{orderId: $orderId, key: $key}';
  }
}

/// generated route for
/// [ContactsView]
class ContactsRouter extends PageRouteInfo<void> {
  const ContactsRouter()
      : super(
          ContactsRouter.name,
          path: '',
        );

  static const String name = 'ContactsRouter';
}

/// generated route for
/// [LegalDocumentsView]
class LegalDocumentsRoute extends PageRouteInfo<void> {
  const LegalDocumentsRoute()
      : super(
          LegalDocumentsRoute.name,
          path: 'legal_documents',
        );

  static const String name = 'LegalDocumentsRoute';
}

/// generated route for
/// [AboutAppView]
class AboutAppRoute extends PageRouteInfo<void> {
  const AboutAppRoute()
      : super(
          AboutAppRoute.name,
          path: 'about_app',
        );

  static const String name = 'AboutAppRoute';
}
