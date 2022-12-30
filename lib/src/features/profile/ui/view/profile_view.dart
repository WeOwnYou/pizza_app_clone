import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/int_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/string_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/methods/platform_dependent_methods.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/core/ui/widgets/bouncing_widget.dart';
import 'package:dodo_clone/src/core/ui/widgets/corporate_button.dart';
import 'package:dodo_clone/src/core/ui/widgets/platform_unique_widget.dart';
import 'package:dodo_clone/src/core/ui/widgets/product_image_widget.dart';
import 'package:dodo_clone/src/features/bonuses/bloc/bonuses_bloc.dart';
import 'package:dodo_clone/src/features/bonuses/view/bonuses_view.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_cubit.dart';
import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:dodo_clone/src/features/profile/ui/view/settings_view.dart';
import 'package:dodo_clone/src/features/shopping_cart/bloc/shopping_cart_cubit.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:person_repository/person_repository.dart';

const _kMainVerticalPadding = 20.0;
const _kMainHorizontalPadding = 15.0;
const double minChildSize = 0.72;
const double maxChildSize = 1;
const double _kFlexibleFromHeight = 0.2;

class ProfileView extends StatefulWidget {
  static const title = 'Профиль';
  static Widget androidIcon(bool selected) =>
      _BuildProfileIcon(selected: selected);
  static const iosIcon = Icon(CupertinoIcons.person);

  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ScrollController _controller;
  late final TabsRouter tabsController;
  late int currentIndex;
  double topOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    tabsController = AutoTabsRouter.of(context)
      ..addListener(tabsControllerListener);
    currentIndex = tabsController.activeIndex;
    _controller = ScrollController()..addListener(_scrollControllerListener);
    // _draggableController = DraggableScrollableController()
    //   ..addListener(draggableControllerListener);
  }
  //
  // void draggableControllerListener() {
  //   if (!_draggableController.isAttached) return;
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   });
  // }

  void _scrollControllerListener() {
    setState(() {});
  }

  void tabsControllerListener() {
    const duration = Duration(milliseconds: 300);
    const curve = Curves.easeInOut;
    if (currentIndex == tabsController.activeIndex &&
        tabsController.activeIndex == 1) {
      if (!mounted) return;
      AutoRouter.of(context).canPop()
          ? AutoRouter.of(context).popTop()
          : _controller.animateTo(
              minChildSize,
              duration: duration,
              curve: curve,
            );
    } else {
      currentIndex = tabsController.activeIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mainBluePurple,
            AppColors.bgLightOrange,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.43],
        ),
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStateStatus.initial ||
              state.status == ProfileStateStatus.loading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Scaffold(
            appBar: const _BuildAppBarWidget(),
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                _BuildScrollableBackgroundWidget(
                  controller: _controller,
                  height:
                      MediaQuery.of(context).size.height * _kFlexibleFromHeight,
                ),
                _BuildBodyWidget(
                  controller: _controller,
                  height:
                      MediaQuery.of(context).size.height * _kFlexibleFromHeight,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BuildAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const _BuildAppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight * 1.4,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return Text(
                  'Привет, ${state.person.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                PlatformDependentMethod.callFutureByPlatform(
                  androidMethod: () => showMaterialModalBottomSheet<void>(
                    // expand: true,
                    enableDrag: false,
                    isDismissible: false,
                    useRootNavigator: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) {
                      return SettingsView(
                        parentContext: context,
                      );
                    },
                  ),
                  iosMethod: () => showCupertinoModalBottomSheet<void>(
                    enableDrag: false,
                    isDismissible: false,
                    useRootNavigator: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) {
                      return SettingsView(
                        parentContext: context,
                      );
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.settings),
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _BuildScrollableBackgroundWidget extends StatelessWidget {
  final ScrollController controller;
  final double height;
  const _BuildScrollableBackgroundWidget({
    required this.controller,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // top: height,
      top: max(
        0,
        controller.hasClients ? (height - controller.offset) : height,
      ),
      left: 0,
      right: 0,
      bottom: 0,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _BuildBodyWidget extends StatelessWidget {
  final ScrollController controller;
  final double height;
  const _BuildBodyWidget({
    required this.controller,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverPersistentHeader(
          delegate: _HeaderDelegate(controller: controller, height: height),
        ),
        const _BuildPromotionBlockWidget()
      ],
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final ScrollController controller;
  final double height;

  const _HeaderDelegate({
    required this.controller,
    required this.height,
  });

  double get topPadding => min(
        _kMainVerticalPadding * 2,
        max(
          0,
          _kMainVerticalPadding -
              (controller.hasClients ? controller.offset / 10 : 0),
        ),
      );

  double get bottomPadding => min(
        _kMainVerticalPadding * 2,
        max(
          0,
          _kMainVerticalPadding +
              (controller.hasClients ? controller.offset / 10 : 0),
        ),
      );

  double _getOpacity(BuildContext context) {
    double result = 1;
    if (!controller.hasClients) return result;
    result = 1 -
        (controller.offset /
            ((MediaQuery.of(context).size.height * 0.2) / 100) /
            100);
    if (result < 0) {
      result = 0;
    } else if (result > 1) {
      result = 1;
    }
    return result;
  }

  Future<void> _androidBonusViewBuilder(BuildContext context) {
    final shoppingCartCubitState = context.read<ShoppingCartCubit>().state;
    return showMaterialModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => BlocProvider(
        // lazy: false,
        child: BonusesView(
          parentContext: context,
        ),
        create: (ctx) => BonusesBloc(
          dodoCloneRepository: context.read<IDodoCloneRepository>(),
          personRepository: context.read<PersonRepository>(),
        )..add(
          BonusesInitializeEvent(
            coinsInCart:
            shoppingCartCubitState.shoppingCartProducts.coinsSpent,
            numberOfBonusOffersInCart: shoppingCartCubitState
                .shoppingCartProducts.numberOfBonusesInCart,
          ),
        ),
      ),
    );
  }

  Future<void> _iosBonusViewBuilder(BuildContext context) {
    final shoppingCartCubitState = context.read<ShoppingCartCubit>().state;
    return showCupertinoModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => BlocProvider(
        child: BonusesView(
          parentContext: context,
        ),
        // lazy: false,
        create: (ctx) => BonusesBloc(
          dodoCloneRepository: context.read<IDodoCloneRepository>(),
          personRepository: context.read<PersonRepository>(),
        )..add(
          BonusesInitializeEvent(
            coinsInCart:
            shoppingCartCubitState.shoppingCartProducts.coinsSpent,
            numberOfBonusOffersInCart: shoppingCartCubitState
                .shoppingCartProducts.numberOfBonusesInCart,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      fit: StackFit.expand,
      children: [
        const SizedBox.expand(),
        Positioned(
          top: shrinkOffset,
          bottom: controller.offset > 0 ? 0 - shrinkOffset : null,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: _getOpacity(context),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final addressesLength =
                    BlocProvider.of<AddressCubit>(context, listen: true)
                        .state
                        .deliveryAddresses
                        .length;
                return SizedBox(
                  height: height,
                  child: ListView(
                    padding: EdgeInsets.only(
                      top: topPadding,
                      bottom: bottomPadding,
                    ),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _BuildTopsideCartWidget(
                        title: 'Додокоины',
                        subtitle: '${state.person.dodoCoins}',
                        bottom: 'Нажмите, \nчтобы потратить',
                        image: const ClipPath(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: FaIcon(
                            FontAwesomeIcons.bitcoin,
                            size: 60,
                          ),
                        ),
                        onPressed: () {
                          PlatformDependentMethod.callFutureByPlatform(
                            androidMethod: () => _androidBonusViewBuilder(context),
                            iosMethod: () => _iosBonusViewBuilder(context),
                          );
                        },
                      ),
                      _BuildTopsideCartWidget(
                        title: 'История\nзаказов',
                        bottom:
                            '${state.ordersHistory.total} ${state.ordersHistory.total.declension('заказ', 'заказа', 'заказов')}',
                        onPressed: () => AppRouter.instance().push(
                          const OrdersHistoryRoute(),
                        ),
                      ),
                      _BuildTopsideCartWidget(
                        title: 'Адреса\nдоставки',
                        bottom:
                            '$addressesLength ${addressesLength.declension('адрес', 'адреса', 'адресов')}',
                        onPressed: () {
                          AppRouter.instance()
                              .push(const DeliveryAddressesRoute());
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _BuildPromotionBlockWidget extends StatefulWidget {
  const _BuildPromotionBlockWidget({Key? key}) : super(key: key);

  @override
  State<_BuildPromotionBlockWidget> createState() =>
      _BuildPromotionBlockWidgetState();
}

class _BuildPromotionBlockWidgetState
    extends State<_BuildPromotionBlockWidget> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: _kMainHorizontalPadding,
            vertical: _kMainVerticalPadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const Text(
                'Мои акции',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text('Всего одна, зато какая'),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                // TODO(fix): hardCode size!!!!
                height: 150,
                child: PageView(
                  onPageChanged: (page) {
                    setState(
                      () {
                        pageIndex = page;
                      },
                    );
                  },
                  children: state.promotions.map(
                    (promotion) {
                      return _BuildPromotionCardWidget(promotion: promotion);
                    },
                  ).toList(),
                ),
              ),
              if (state.promotions.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.promotions.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 15,
                      height: 5,
                      decoration: BoxDecoration(
                        color: index == pageIndex
                            ? AppColors.mainIconGrey
                            : AppColors.mainBgGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Миссии',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Выполняйте и получайте додокоины'),
              const SizedBox(
                height: 10,
              ),
              ...state.missions.map(
                (e) => _BuildMissionsWidget(
                  mission: e,
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class _BuildPromoBlockWidget extends StatefulWidget {
  final DraggableScrollableController controller;
  const _BuildPromoBlockWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  State<_BuildPromoBlockWidget> createState() => _BuildPromoBlockWidgetState();
}

class _BuildPromoBlockWidgetState extends State<_BuildPromoBlockWidget> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: widget.controller,
      initialChildSize: minChildSize,
      minChildSize: minChildSize,
      builder: (context, controller) => Container(
        padding: const EdgeInsets.all(
          kMainHorizontalPadding,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              controller: controller,
              children: [
                const Text(
                  'Мои акции',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text('Всего одна, зато какая'),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  // TODO(fix): hardCode size!!!!
                  height: 150,
                  child: PageView(
                    onPageChanged: (page) {
                      setState(
                        () {
                          pageIndex = page;
                        },
                      );
                    },
                    children: state.promotions.map(
                      (promotion) {
                        return _BuildPromotionCardWidget(promotion: promotion);
                      },
                    ).toList(),
                  ),
                ),
                if (state.promotions.length > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      state.promotions.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 15,
                        height: 5,
                        decoration: BoxDecoration(
                          color: index == pageIndex
                              ? AppColors.mainIconGrey
                              : AppColors.mainBgGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Миссии',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Выполняйте и получайте додокоины'),
                const SizedBox(
                  height: 10,
                ),
                ...state.missions.map(
                  (e) => _BuildMissionsWidget(
                    mission: e,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BuildTopsideCartWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String bottom;
  final Widget? image;
  final VoidCallback onPressed;
  const _BuildTopsideCartWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.bottom,
    this.image,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: EdgeInsets.only(
          left: 10,
          top: 10,
          right: image == null ? 50.0 : 0.0,
          bottom: image == null ? kMainHorizontalPadding : 0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (subtitle != null)
              const SizedBox(
                height: 5,
              ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            const Spacer(),
            // if (subtitle == null) const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bottom,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mainIconGrey,
                  ),
                ),
                if (image != null) image!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildPromotionCardWidget extends StatelessWidget {
  final Promotion promotion;
  const _BuildPromotionCardWidget({required this.promotion, Key? key})
      : super(key: key);

  void _onActionTap(BuildContext context) {
    showModalBottomSheet<dynamic>(
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      context: context,
      builder: (_) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kMainHorizontalPadding),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: kMainHorizontalPadding,
                    ),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.mainTextGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (promotion.image == null)
                  const SizedBox(
                    height: 200,
                  )
                else
                  Center(
                    child: ProductImageWidget(
                      url: promotion.image!,
                      fit: BoxFit.contain,
                      height: 150,
                    ),
                  ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  promotion.expires.expireDate,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  promotion.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${promotion.title} ${promotion.description}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.mainIconGrey,
                  ),
                ),
                const Spacer(),
                CorporateButton(
                  margin:
                      const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
                  isActive: promotion.expires.stringToDate.compareTo(
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day + 1,
                        ),
                      ) >=
                      0,
                  child: const Text(
                    'Применить промокод',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  widthFactor: 1,
                  onTap: () {},
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onActionTap(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0.5,
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (promotion.image != null)
                  Expanded(
                    child: ProductImageWidget(
                      url: promotion.image!,
                    ),
                  ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          promotion.expires.expireDate,
                          style: TextStyle(
                            color: promotion.expires.stringToDate
                                        .difference(DateTime.now())
                                        .inHours <
                                    48
                                ? AppColors.mainRed
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 5,
                          ),
                          child: Text(
                            promotion.title,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CorporateButton(
                          widthFactor: 0.45,
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          isActive: promotion.expires.stringToDate.compareTo(
                                DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day + 1,
                                ),
                              ) >=
                              0,
                          child: const Text('Применить'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Positioned(
              right: 0,
              child: Icon(
                Icons.info_outline,
                size: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildMissionsWidget extends StatefulWidget {
  final Mission mission;
  const _BuildMissionsWidget({Key? key, required this.mission})
      : super(key: key);

  @override
  State<_BuildMissionsWidget> createState() => _BuildMissionsWidgetState();
}

class _BuildMissionsWidgetState extends State<_BuildMissionsWidget> {
  final _imageKey = GlobalKey();

  void _openMissionDetails(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      showCupertinoModalBottomSheet<dynamic>(
        useRootNavigator: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return _BuildMissionDetailsWidget(
            mission: widget.mission,
          );
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      showMaterialModalBottomSheet<dynamic>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return _BuildMissionDetailsWidget(mission: widget.mission);
        },
      );
    } else {
      UnimplementedError('this platform is not supported');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openMissionDetails(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImageWidget(
                  key: _imageKey,
                  url: widget.mission.image ?? AppImages.defaultImageSvg,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMainHorizontalPadding * 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: kMainHorizontalPadding,
                      ),
                      Text(
                        widget.mission.expires.expireDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.mission.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      CorporateButton(
                        backgroundColor: AppColors.mainBluePurple,
                        isActive: true,
                        onTap: () {},
                        widthFactor: 1,
                        child: const Text(
                          'Приступить',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            if (widget.mission.reward != null &&
                _imageKey.currentContext != null)
              Positioned(
                top:
                    (_imageKey.currentContext!.findRenderObject() as RenderBox?)
                            ?.size
                            .height ??
                        100,
                left: kMainHorizontalPadding * 2,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '+${widget.mission.reward!} D',
                    style: const TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mainBluePurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _BuildProfileIcon extends StatelessWidget {
  const _BuildProfileIcon({
    Key? key,
    required this.selected,
  }) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppIcons.profilePicture,
      height: 24,
      color: selected ? AppColors.mainBgOrange : AppColors.mainIconGrey,
      frameBuilder: (ctx, child, _, __) => Stack(
        children: [
          child,
          Positioned(
            top: 11.5,
            left: 6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: selected ? Colors.black : AppColors.mainIconGrey,
                    shape: BoxShape.circle,
                  ),
                  width: 3,
                  height: 3,
                ),
                const SizedBox(
                  width: 6,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: selected ? Colors.black : AppColors.mainIconGrey,
                    shape: BoxShape.circle,
                  ),
                  width: 3,
                  height: 3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _BuildMissionDetailsWidget extends StatelessWidget {
  final Mission mission;
  const _BuildMissionDetailsWidget({required this.mission, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformUniqueWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            AppRouter.instance().pop();
          },
          child: const Icon(
            Icons.close,
            color: AppColors.mainIconGrey,
          ),
        ),
      ),
      child: Material(child: _buildContent(context)),
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
  }

  Widget _buildContent(
    BuildContext context,
  ) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          if (mission.image != null)
            ProductImageWidget(
              height: MediaQuery.of(context).size.height * 0.5,
              url: mission.image!,
              fit: BoxFit.fitHeight,
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: kMainHorizontalPadding),
              padding: const EdgeInsets.all(5),
              child: const Text(
                '+200 D',
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: AppColors.mainBluePurple,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kMainHorizontalPadding * 1.9,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.expires.expireDate,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  mission.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Условия: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${mission.title} ${mission.description}',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                CorporateButton(
                  backgroundColor: AppColors.mainBluePurple,
                  isActive: true,
                  onTap: () {},
                  widthFactor: 1,
                  child: const Text(
                    'Приступить',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
