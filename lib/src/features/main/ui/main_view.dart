import 'dart:async';
import 'dart:ui';

import 'package:address_repository/address_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:badges/badges.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/core/ui/widgets/platform_unique_widget.dart';
import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
import 'package:dodo_clone/src/features/contacts/domain/entity/message.dart';
import 'package:dodo_clone/src/features/contacts/ui/contacts_export.dart';
import 'package:dodo_clone/src/features/main/bloc/main_bloc/main_cubit.dart';
import 'package:dodo_clone/src/features/main/bloc/main_bloc/main_state.dart';
import 'package:dodo_clone/src/features/menu/bloc/menu_bloc/menu_bloc.dart';
import 'package:dodo_clone/src/features/menu/ui/menu_export.dart';
import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:dodo_clone/src/features/profile/ui/profile_export.dart';
import 'package:dodo_clone/src/features/shopping_cart/bloc/shopping_cart_cubit.dart';
import 'package:dodo_clone/src/features/shopping_cart/ui/shopping_cart_export.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:person_repository/person_repository.dart';

const channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.max,
);

class MainView extends StatefulWidget implements AutoRouteWrapper {
  final City? city;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  MainView({
    this.city,
    Key? key,
  })  : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(),
        super(key: key);

  Future<void> _initNotifications(BuildContext context) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_local_pizza'),
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (_) async {
        final contactsCubit = context.read<ContactsCubit>();
        while (AppRouter.instance().canPop() &&
            contactsCubit.state.chatState == ChatState.disabled) {
          await AppRouter.instance().popTop();
        }
        await AppRouter.instance().navigate(const ContactsRoute());
        // ignore: use_build_context_synchronously
        unawaited(context.read<ContactsCubit>().initChat());
      },
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    final personRepository = context.read<PersonRepository>();
    final dodoCloneRepository = context.read<IDodoCloneRepository>();
    final addressRepository = context.read<IAddressRepository>();
    _initNotifications(context);
    return RepositoryProvider(
      create: (ctx) => addressRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => MainCubit(
              dodoCloneRepository,
            ),
          ),
          BlocProvider(
            lazy: false,
            create: (ctx) => MenuBloc(
              dodoCloneRepository: dodoCloneRepository,
              personRepository: personRepository,
              addressRepository: addressRepository,
            )..add(MenuInitializeEvent(city)),
          ),
          BlocProvider(
            create: (ctx) => ProfileBloc(
              personRepository,
              dodoCloneRepository,
              addressRepository,
              ProfileState.empty,
            )..add(ProfileLoadEvent()),
            lazy: false,
          ),
          BlocProvider(
            create: (ctx) => ShoppingCartCubit(
              dodoCloneRepository: dodoCloneRepository,
              personRepository: personRepository,
              addressRepository: addressRepository,
            ),
            lazy: false,
          )
        ],
        child: this,
      ),
    );
  }

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int? personId;

  @override
  void initState() {
    setPersonId();
    super.initState();
  }

  Future<void> setPersonId() async {
    personId = (await context.read<PersonRepository>().person).id;
  }

  Widget _androidBuilder(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    final tabsRouter = AutoTabsRouter.of(context);
    return Scaffold(
      extendBody: true,
      body: FadeTransition(
        opacity: animation,
        child: child,
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              if (index == tabsRouter.activeIndex) {
                tabsRouter.notifyAll();
              }
              tabsRouter.setActiveIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                label: 'Меню',
                icon: MenuView.androidIcon(tabsRouter.isMenu),
              ),
              BottomNavigationBarItem(
                label: 'Профиль',
                icon: ProfileView.androidIcon(tabsRouter.isProfile),
              ),
              BottomNavigationBarItem(
                label: 'Контакты',
                icon: BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (oldState, newState) {
                    return oldState.person != newState.person;
                  },
                  builder: (context, profileState) {
                    return BlocBuilder<ContactsCubit, ContactsState>(
                      builder: (context, state) {
                        final unreadMessages = state.messages
                            .unreadMessages(profileState.person.id);
                        return Badge(
                          showBadge: unreadMessages.isNotEmpty &&
                              profileState.person.isNotEmpty,
                          position: const BadgePosition(top: -9, end: -9),
                          badgeContent: Text(
                            unreadMessages.length.toString(),
                          ),
                          child: ContactsView.androidIcon(tabsRouter.isContacts),
                        );
                      },
                    );
                  },
                ),
              ),
              BottomNavigationBarItem(
                label: 'Корзина',
                icon: BlocBuilder<MainCubit, MainState>(
                  builder: (context, state) {
                    return Badge(
                      badgeColor: AppColors.mainRed,
                      showBadge: state.shoppingCartLength > 0,
                      badgeContent: Text(
                        '${state.shoppingCartLength}',
                      ),
                      child: ShoppingCartView.androidIcon(tabsRouter.isShoppingCart),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context, Widget child) {
    final tabsRouter = AutoTabsRouter.of(context);
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        onTap: (index) {
          if (index == tabsRouter.activeIndex) {
            tabsRouter.notifyAll();
          }
          tabsRouter.setActiveIndex(index);
        },
        items: [
          const BottomNavigationBarItem(
            label: 'Меню',
            icon: Icon(Icons.restaurant_menu),
          ),
          const BottomNavigationBarItem(
            label: 'Профиль',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Контакты',
            icon: BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (oldState, newState) {
                return oldState.person != newState.person;
              },
              builder: (context, profileState) {
                return BlocBuilder<ContactsCubit, ContactsState>(
                  builder: (context, state) {
                    final unreadMessages =
                        state.messages.unreadMessages(profileState.person.id);
                    return Badge(
                      showBadge: unreadMessages.isNotEmpty &&
                          profileState.person.isNotEmpty,
                      position: const BadgePosition(top: -9, end: -9),
                      badgeContent: Text(
                        unreadMessages.length.toString(),
                      ),
                      child: const Icon(Icons.location_on),
                    );
                  },
                );
              },
            ),
          ),
          BottomNavigationBarItem(
            label: 'Корзина',
            icon: BlocBuilder<MainCubit, MainState>(
              builder: (context, state) {
                return Badge(
                  badgeColor: AppColors.mainRed,
                  showBadge: state.shoppingCartLength > 0,
                  badgeContent: Text(
                    '${state.shoppingCartLength}',
                  ),
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          // onGenerateRoute: AutoRouter.of(context).,
          builder: (context) => tabsRouter.stack[index].buildPage(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      buildWhen: (oldState, newState) {
        if (oldState.messages.length != newState.messages.length &&
            oldState.messages.isNotEmpty &&
            newState.messages.isNotEmpty) {
          if (newState.messages.last.userId != personId &&
              personId != null &&
              oldState.chatState != ChatState.active) {
            widget.flutterLocalNotificationsPlugin.show(
              newState.messages.last.messageId.hashCode,
              newState.messages.last.username,
              newState.messages.last.textMessage,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  priority: Priority.high,
                ),
              ),
            );
          }
        }
        return false;
      },
      builder: (context, state) {
        return AutoTabsRouter(
          lazyLoad: false,
          routes: const [
            MenuRoute(),
            ProfileRoute(),
            ContactsRoute(),
            ShoppingCartRoute(),
          ],
          builder: (ctx, child, animation) {
            return PlatformUniqueWidget(
              androidBuilder: (context) =>
                  _androidBuilder(context, animation, child),
              iosBuilder: (context) =>
                  _androidBuilder(context, animation, child),
              // iosBuilder: (context) => _iosBuilder(context, child),
            );
          },
        );
      },
    );
  }
}

extension IndexInfo on TabsRouter {
  bool get isMenu => activeIndex == 0;
  bool get isProfile => activeIndex == 1;
  bool get isContacts => activeIndex == 2;
  bool get isShoppingCart => activeIndex == 3;
}