// import 'dart:async';
//
// import 'package:address_repository/address_repository.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:badges/badges.dart';
// import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
// import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
// import 'package:dodo_clone/src/core/ui/widgets/platform_unique_widget.dart';
// import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
// import 'package:dodo_clone/src/features/contacts/domain/entity/message.dart';
// import 'package:dodo_clone/src/features/contacts/ui/view/contacts_view.dart';
// import 'package:dodo_clone/src/features/main/bloc/main_bloc/main_cubit.dart';
// import 'package:dodo_clone/src/features/main/bloc/main_bloc/main_state.dart';
// import 'package:dodo_clone/src/features/menu/bloc/menu_bloc/menu_bloc.dart';
// import 'package:dodo_clone/src/features/menu/ui/view/menu_view/menu_view.dart';
// import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
// import 'package:dodo_clone/src/features/profile/ui/view/profile_view.dart';
// import 'package:dodo_clone/src/features/shopping_cart/bloc/shopping_cart_cubit.dart';
// import 'package:dodo_clone/src/features/shopping_cart/ui/shopping_cart_view.dart';
// import 'package:dodo_clone_repository/dodo_clone_repository.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:person_repository/person_repository.dart';
//
// const channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   importance: Importance.max,
// );
//
// class MainView extends StatefulWidget implements AutoRouteWrapper {
//   final City? city;
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   MainView({
//     this.city,
//     Key? key,
//   })  : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(),
//         super(key: key);
//
//   Future<void> _initNotifications(BuildContext context) async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//     const initializationSettings = InitializationSettings(
//       android: AndroidInitializationSettings('ic_stat_local_pizza'),
//       iOS: DarwinInitializationSettings(),
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (_) async {
//         while (AppRouter.instance().canPop()) {
//           await AppRouter.instance().popTop();
//         }
//         await AppRouter.instance().navigate(const ContactsRoute());
//         // ignore: use_build_context_synchronously
//         unawaited(context.read<ContactsCubit>().initChat());
//       },
//     );
//   }
//
//   @override
//   Widget wrappedRoute(BuildContext context) {
//     final personRepository = context.read<PersonRepository>();
//     final dodoCloneRepository = context.read<IDodoCloneRepository>();
//     final addressRepository = context.read<IAddressRepository>();
//     _initNotifications(context);
//     return RepositoryProvider(
//       create: (ctx) => addressRepository,
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (ctx) => MainCubit(
//               dodoCloneRepository,
//             ),
//           ),
//           BlocProvider(
//             lazy: false,
//             create: (ctx) => MenuBloc(
//               dodoCloneRepository: dodoCloneRepository,
//               personRepository: personRepository,
//               addressRepository: addressRepository,
//             )..add(MenuInitializeEvent(city)),
//           ),
//           BlocProvider(
//             create: (ctx) => ProfileBloc(
//               personRepository,
//               dodoCloneRepository,
//               addressRepository,
//               ProfileState.empty,
//             )..add(ProfileLoadEvent()),
//             lazy: false,
//           ),
//           BlocProvider(
//             create: (ctx) => ShoppingCartCubit(
//               dodoCloneRepository: dodoCloneRepository,
//               personRepository: personRepository,
//               addressRepository: addressRepository,
//             ),
//             lazy: false,
//           )
//         ],
//         child: this,
//       ),
//     );
//   }
//
//   @override
//   State<MainView> createState() => _MainViewState();
// }
//
// class _MainViewState extends State<MainView> {
//   int? personId;
//
//   @override
//   void initState() {
//     setPersonId();
//     super.initState();
//   }
//
//   Future<void> setPersonId() async {
//     personId = (await context.read<PersonRepository>().person).id;
//   }
//
//   void onBottomNavBarItemTap(BuildContext context, int index) {
//     final tabsRouter = AutoTabsRouter.of(context);
//     {
//       if (index == tabsRouter.activeIndex) {
//         tabsRouter.notifyAll();
//       }
//       tabsRouter.setActiveIndex(index);
//     }
//   }
//
//   Widget _iosMainBody(BuildContext context) {
//     final tabsRouter = AutoTabsRouter.of(context);
//     return CupertinoTabScaffold(
//       tabBar: CupertinoTabBar(
//         currentIndex: tabsRouter.activeIndex,
//         onTap: (index) => onBottomNavBarItemTap(context, index),
//         items: [
//           BottomNavigationBarItem(
//             label: MenuView.title,
//             icon: MenuView.iosIcon(tabsRouter.isMenu),
//           ),
//           const BottomNavigationBarItem(
//             label: ProfileView.title,
//             icon: ProfileView.iosIcon,
//           ),
//           BottomNavigationBarItem(
//             label: ContactsView.title,
//             icon: ContactsView.iosIcon(tabsRouter.isContacts),
//           ),
//           const BottomNavigationBarItem(
//             label: ShoppingCartView.title,
//             icon: ShoppingCartView.iosIcon,
//           ),
//         ],
//       ),
//       tabBuilder: (context, index) {
//         return CupertinoTabView(
//           builder: (context) => tabsRouter.stack[index].buildPage(context),
//         );
//       },
//     );
//   }
//
//   Widget _androidMainBody(BuildContext context, Widget child) {
//     final tabsRouter = AutoTabsRouter.of(context);
//     return Scaffold(
//       body: child,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: tabsRouter.activeIndex,
//         onTap: (index) => onBottomNavBarItemTap(context, index),
//         items: [
//           BottomNavigationBarItem(
//             label: MenuView.title,
//             icon: MenuView.androidIcon(tabsRouter.isMenu),
//           ),
//           BottomNavigationBarItem(
//             label: ProfileView.title,
//             icon: ProfileView.androidIcon(tabsRouter.isProfile),
//           ),
//           BottomNavigationBarItem(
//             label: ContactsView.title,
//             icon: BlocBuilder<ProfileBloc, ProfileState>(
//               buildWhen: (oldState, newState) {
//                 return oldState.person != newState.person;
//               },
//               builder: (context, profileState) {
//                 return BlocBuilder<ContactsCubit, ContactsState>(
//                   builder: (context, state) {
//                     final unreadMessages =
//                     state.messages.unreadMessages(profileState.person.id);
//                     return Badge(
//                       showBadge: unreadMessages.isNotEmpty &&
//                           profileState.person.isNotEmpty,
//                       position: const BadgePosition(top: -9, end: -9),
//                       badgeContent: Text(
//                         unreadMessages.length.toString(),
//                       ),
//                       child: ContactsView.androidIcon(tabsRouter.isContacts),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           BottomNavigationBarItem(
//             label: ShoppingCartView.title,
//             icon: BlocBuilder<MainCubit, MainState>(
//               builder: (context, state) {
//                 return Badge(
//                   badgeColor: AppColors.mainRed,
//                   showBadge: state.shoppingCartLength > 0,
//                   badgeContent: Text(
//                     '${state.shoppingCartLength}',
//                   ),
//                   child:
//                   ShoppingCartView.androidIcon(tabsRouter.isShoppingCart),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ContactsCubit, ContactsState>(
//       buildWhen: (oldState, newState) {
//         if (oldState.messages.length != newState.messages.length &&
//             oldState.messages.isNotEmpty &&
//             newState.messages.isNotEmpty) {
//           if (newState.messages.last.userId != personId &&
//               personId != null &&
//               oldState.chatState != ChatState.active) {
//             widget.flutterLocalNotificationsPlugin.show(
//               newState.messages.last.messageId.hashCode,
//               newState.messages.last.username,
//               newState.messages.last.textMessage,
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   channel.id,
//                   channel.name,
//                   priority: Priority.high,
//                 ),
//               ),
//             );
//           }
//         }
//         return false;
//       },
//       builder: (context, state) {
//         return AutoTabsRouter(
//           lazyLoad: false,
//           routes: const [
//             MenuRoute(),
//             ProfileRoute(),
//             ContactsRoute(),
//             ShoppingCartRoute(),
//           ],
//           builder: (ctx, child, animation) {
//             return PlatformUniqueWidget(
//               androidBuilder: (context) => _androidMainBody(ctx, child),
//               iosBuilder: (context) => _iosMainBody(ctx),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
//
// /*
// const channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   importance: Importance.max,
// );
//
// class MainView extends StatefulWidget implements AutoRouteWrapper {
//   final City? city;
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   MainView({
//     this.city,
//     Key? key,
//   })  : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(),
//         super(key: key);
//
//   Future<void> _initNotifications(BuildContext context) async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//     const initializationSettings = InitializationSettings(
//       android: AndroidInitializationSettings('ic_stat_local_pizza'),
//       iOS: DarwinInitializationSettings(),
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (_) async {
//         while (AppRouter.instance().canPop()) {
//           await AppRouter.instance().popTop();
//         }
//         await AppRouter.instance().navigate(const ContactsRoute());
//         // ignore: use_build_context_synchronously
//         context.read<ContactsCubit>().initChat();
//       },
//     );
//   }
//
//   @override
//   Widget wrappedRoute(BuildContext context) {
//     final personRepository = context.read<PersonRepository>();
//     final dodoCloneRepository = context.read<IDodoCloneRepository>();
//     final addressRepository = context.read<IAddressRepository>();
//     _initNotifications(context);
//     return RepositoryProvider(
//       create: (ctx) => addressRepository,
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (ctx) => MainCubit(
//               dodoCloneRepository,
//             ),
//           ),
//           BlocProvider(
//             lazy: false,
//             create: (ctx) => MenuBloc(
//               dodoCloneRepository: dodoCloneRepository,
//               personRepository: personRepository,
//               addressRepository: addressRepository,
//             )..add(MenuInitializeEvent(city)),
//           ),
//           BlocProvider(
//             create: (ctx) => ProfileBloc(
//               personRepository,
//               dodoCloneRepository,
//               addressRepository,
//               ProfileState.empty,
//             )..add(ProfileLoadEvent()),
//             lazy: false,
//           ),
//           BlocProvider(
//             create: (ctx) => ShoppingCartCubit(
//               dodoCloneRepository: dodoCloneRepository,
//               personRepository: personRepository,
//             ),
//             lazy: false,
//           )
//         ],
//         child: this,
//       ),
//     );
//   }
//
//   @override
//   State<MainView> createState() => _MainViewState();
// }
//
// class _MainViewState extends State<MainView> {
//   final _tabBarRoutes = const [
//     MenuRoute(),
//     ProfileRoute(),
//     ContactsRoute(),
//     ShoppingCartRoute(),
//   ];
//   int? personId;
//
//   @override
//   void initState() {
//     setPersonId();
//     super.initState();
//   }
//
//   Future<void> setPersonId() async {
//     personId = (await context.read<PersonRepository>().person).id;
//   }
//
//   void onBottomNavBarItemTap(BuildContext context, int index) {
//     final tabsRouter = AutoTabsRouter.of(context);
//     {
//       if (index == tabsRouter.activeIndex) {
//         tabsRouter.notifyAll();
//       }
//       tabsRouter.setActiveIndex(index);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ContactsCubit, ContactsState>(
//       buildWhen: (oldState, newState) {
//         if (oldState.messages.length != newState.messages.length &&
//             oldState.messages.isNotEmpty &&
//             newState.messages.isNotEmpty) {
//           if (newState.messages.last.userId != personId &&
//               personId != null &&
//               oldState.chatState != ChatState.active) {
//             widget.flutterLocalNotificationsPlugin.show(
//               newState.messages.last.messageId.hashCode,
//               newState.messages.last.username,
//               newState.messages.last.textMessage,
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   channel.id,
//                   channel.name,
//                   priority: Priority.high,
//                 ),
//               ),
//             );
//           }
//         }
//         return false;
//       },
//       builder: (context, state) {
//         return AutoTabsRouter(
//           lazyLoad: false,
//           routes: _tabBarRoutes,
//           builder: (ctx, child, animation) {
//             return PlatformUniqueWidget(
//               androidBuilder: (context) => _androidMainBody(ctx, child),
//               iosBuilder: (context) => _iosMainBody(ctx),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//  */
