import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/list_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/methods/platform_dependent_methods.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/core/ui/widgets/bouncing_widget.dart';
import 'package:dodo_clone/src/core/ui/widgets/product_image_widget.dart';
import 'package:dodo_clone/src/features/bonuses/bloc/bonuses_bloc.dart';
import 'package:dodo_clone/src/features/bonuses/view/bonuses_view.dart';
import 'package:dodo_clone/src/features/location/ui/view/select_city_view.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_cubit.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_state.dart';
import 'package:dodo_clone/src/features/menu/bloc/menu_bloc/menu_bloc.dart';
import 'package:dodo_clone/src/features/menu/ui/utils/constants.dart';
import 'package:dodo_clone/src/features/menu/ui/view/address_view/select_address_widget.dart';
import 'package:dodo_clone/src/features/menu/ui/widgets/product_card.dart';
import 'package:dodo_clone/src/features/menu/ui/widgets/toggle_button.dart';
import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:dodo_clone/src/features/shopping_cart/bloc/shopping_cart_cubit.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart' show IDodoCloneRepository, ItemsCount;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:person_repository/person_repository.dart';

part 'order_details_widget.dart';
part 'stories_block.dart';
part 'app_bar_block.dart';
part 'categories_block.dart';
part 'failure_widget.dart';
part 'animated_product.dart';
part 'special_products_block.dart';
part 'products_list.dart';

class MenuView extends StatefulWidget {
  static const title = 'Меню';
  static Widget androidIcon(bool selected) => _BuildMenuIcon(selected: selected);
  static Widget iosIcon(bool selected) => _BuildMenuIcon(selected: selected);

  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>
    with
        SingleTickerProviderStateMixin<MenuView>,
        AutomaticKeepAliveClientMixin<MenuView> {
  late final ScrollController categoryController;
  late final ScrollController menuController;
  late final AnimationController animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late final double _headerHeight;
  final List<GlobalKey> sectionKeys = [];
  final List<int> blocksHeightsList = [];
  late final TabsRouter tabsController;
  late int currentIndex;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    tabsController = AutoTabsRouter.of(context)
      ..addListener(tabsControllerListener);
    currentIndex = tabsController.activeIndex;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _headerHeight = MediaQuery.of(context).size.height * 0.48;
    });
    menuController = ScrollController()
      ..addListener(() => _menuControllerListener(context));
    categoryController = ScrollController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    _opacityAnimation =
        Tween<double>(begin: 1, end: 0.6).animate(animationController);
    _scaleAnimation =
        Tween<double>(begin: 1, end: 0.4).animate(animationController);
  }

  void tabsControllerListener() {
    const duration = Duration(milliseconds: 600);
    const curve = Curves.easeInOut;
    if (currentIndex == tabsController.activeIndex && tabsController.activeIndex == 0) {
      AutoRouter.of(context).canPop()
          ? AutoRouter.of(context).popTop()
          : menuController.animateTo(
              0,
              duration: duration,
              curve: curve,
            );
    } else {
      currentIndex = tabsController.activeIndex;
    }
  }

  void _calculateBlockHeightsList(MenuState state) {
    if (blocksHeightsList.isNotEmpty) blocksHeightsList.clear();
    for (var i = 0; i < state.sections.length; i++) {
      blocksHeightsList.add(
        MenuConstants.productHeight.toInt() *
            (state.orderType == OrderType.delivery
                    ? state.deliverProducts
                    : state.restaurantProducts)
                .where(
                  (element) => element.sectionId == state.sections[i].id,
                )
                .toList()
                .length,
      );
    }
  }

  void _menuControllerListener(BuildContext context) {
    if (context.read<MenuBloc>().state.menuInAnimation) return;
    final currentPosition = menuController.position.pixels;
    if (blocksHeightsList.isEmpty) return;
    if (currentPosition >= 0 &&
        currentPosition < blocksHeightsList.first + _headerHeight &&
        context.read<MenuBloc>().state.sectionCurrentIndex != 0) {
      _animateCategory(0);
      context.read<MenuBloc>().add(const MenuCategoryChangedEvent(0));
    } else {
      for (var i = 0; i < context.read<MenuBloc>().state.sections.length; i++) {
        if (currentPosition >
                blocksHeightsList.sumPartOfList(i) + _headerHeight &&
            currentPosition <
                blocksHeightsList.sumPartOfList(i + 1) + _headerHeight &&
            context.read<MenuBloc>().state.sectionCurrentIndex != i) {
          _animateCategory(i);
          context.read<MenuBloc>().add(MenuCategoryChangedEvent(i));
        }
      }
    }
    setState(() {});
  }

  Future<void> _animateMenu(int index) async {
    if (blocksHeightsList.isEmpty) return;
    if (index == 0) {
      await menuController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      await menuController.animateTo(
        min(
          menuController.position.maxScrollExtent,
          _headerHeight + blocksHeightsList.sumPartOfList(index),
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
    await _animateCategory(index);
  }

  Future<void> _animateCategory(int index) async {
    final renderBox =
        sectionKeys[index].currentContext?.findRenderObject() as RenderBox;
    final widthHalf = MediaQuery.of(context).size.width / 2;
    final widgetPosition =
        renderBox.localToGlobal(Offset.zero).dx + renderBox.size.width / 2;
    final currentPosition = categoryController.offset;
    await categoryController
        .animateTo(
          min(
            categoryController.position.maxScrollExtent,
            max(
              0,
              currentPosition + widgetPosition - widthHalf,
            ),
          ),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        )
        .then((value) => context.read<MenuBloc>().add(MenuEndScrolling()));
  }

  @override
  void dispose() {
    categoryController.dispose();
    menuController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const _BuildAppBarWidget(),
      body: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {
          _calculateBlockHeightsList(state);
        },
        listenWhen: (old, state) {
          if (old.sections != state.sections) {
            sectionKeys
              ..clear()
              ..addAll(
                List.generate(state.sections.length, (index) => GlobalKey()),
              );
          }
          return state.status == MenuStateStatus.success &&
              sectionKeys.isNotEmpty &&
              (old.deliverProducts != state.deliverProducts ||
                  old.restaurantProducts != state.restaurantProducts);
        },
        buildWhen: (old, next) {
          if (old.sections != next.sections) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          switch (state.status) {
            case MenuStateStatus.initial:
            case MenuStateStatus.loading:
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            case MenuStateStatus.success:
              return Stack(
                children: [
                  _BuildMenuBodyWidget(
                    menuController: menuController,
                    categoryController: categoryController,
                    sectionKeys: sectionKeys,
                    onCategoryTap: _animateMenu,
                  ),
                  AnimatedProduct(
                    animationController: animationController,
                    menuController: menuController,
                    opacity: _opacityAnimation.value,
                    scale: _scaleAnimation.value,
                  )
                ],
              );
            case MenuStateStatus.failure:
              return const _BuildFailureWidget();
          }
        },
      ),
    );
  }
}

class _BuildMenuBodyWidget extends StatelessWidget {
  final ScrollController menuController;
  final ScrollController categoryController;
  final List<GlobalKey> sectionKeys;
  final void Function(int) onCategoryTap;
  const _BuildMenuBodyWidget({
    required this.menuController,
    required this.categoryController,
    required this.sectionKeys,
    required this.onCategoryTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: menuController,
      child: CustomScrollView(
        controller: menuController,
        slivers: [
          const _OrderDetailsWidget(),
          const _StoriesBlock(),
          const SpecialProductsTitle(),
          const _SpecialProductsBlock(),
          _BuildCategoriesBlock(
            sectionKeys: sectionKeys,
            categoryController: categoryController,
            onCategoryTap: onCategoryTap,
          ),
          const _ProductsListBlock(),
        ],
      ),
    );
  }
}

class _BuildMenuIcon extends StatelessWidget {
  const _BuildMenuIcon({
    Key? key,
    required this.selected,
  }) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppIcons.pizzaSlice,
      color: selected ? AppColors.mainBgOrange : AppColors.mainIconGrey,
      height: 18,
      frameBuilder: (ctx, child, _, __) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Transform.rotate(
              angle: 3 * pi / 8,
              child: child,
            ),
          ),
          if (selected) ...[
            Positioned(
              top: 17,
              left: 6,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                width: 5,
                height: 5,
              ),
            ),
            Positioned(
              top: 10,
              left: 3,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                width: 5,
                height: 5,
              ),
            ),
            Positioned(
              top: 13,
              left: 10,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                width: 5,
                height: 5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
