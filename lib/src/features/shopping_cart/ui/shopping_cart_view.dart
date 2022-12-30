import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/int_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/core/ui/widgets/corporate_button.dart';
import 'package:dodo_clone/src/core/ui/widgets/product_image_widget.dart';
import 'package:dodo_clone/src/features/main/ui/custom_paint/shopping_bag_pizza_slice.g.dart';
import 'package:dodo_clone/src/features/menu/bloc/menu_bloc/menu_bloc.dart';
import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:dodo_clone/src/features/shopping_cart/bloc/shopping_cart_cubit.dart';
import 'package:dodo_clone/src/features/shopping_cart/bloc/shopping_cart_state.dart';
import 'package:dodo_clone/src/features/shopping_cart/ui/widgets/sauces_widget.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart'
    hide OrderType;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:person_repository/person_repository.dart';

import 'widgets/cart_item_price_widget.dart';

const _kMinimalPrice = 499;

class ShoppingCartView extends StatelessWidget {
  static const title = 'Корзина';
  static Widget androidIcon(bool selected) =>
      _BuildShoppingCartIcon(selected: selected);
  static const iosIcon = Icon(CupertinoIcons.shopping_cart);

  const ShoppingCartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
        builder: (context, state) {
          switch (state.status) {
            case ShoppingCartStateStatus.initial:
              return const CircularProgressIndicator.adaptive();
            case ShoppingCartStateStatus.empty:
              return const _EmptyShoppingCartWidget();
            case ShoppingCartStateStatus.hasData:
              return const _BuildShoppingCartBodyWidget();
            case ShoppingCartStateStatus.failure:
              return const Text(
                'Что-то пошло не по плану, пытаемся исправить(((',
              );
          }
        },
      ),
    );
  }
}

class _BuildShoppingCartBodyWidget extends StatefulWidget {
  const _BuildShoppingCartBodyWidget({Key? key}) : super(key: key);

  @override
  State<_BuildShoppingCartBodyWidget> createState() =>
      _BuildShoppingCartBodyWidgetState();
}

class _BuildShoppingCartBodyWidgetState
    extends State<_BuildShoppingCartBodyWidget> {
  late int currentIndex;
  final _duration = const Duration(milliseconds: 600);
  final _curve = Curves.easeInOut;
  late final ScrollController shoppingCartController;
  late final TabsRouter tabsController;

  @override
  void initState() {
    super.initState();
    shoppingCartController = ScrollController()
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    tabsController = AutoTabsRouter.of(context)
      ..addListener(tabsControllerListener);
    currentIndex = tabsController.activeIndex;
  }

  void tabsControllerListener() {
    if (currentIndex == tabsController.activeIndex &&
        tabsController.activeIndex == 3) {
      if (!mounted) return;
      AutoRouter.of(context).canPop()
          ? AutoRouter.of(context).popTop()
          : shoppingCartController.animateTo(
              0,
              duration: _duration,
              curve: _curve,
            );
    } else {
      currentIndex = tabsController.activeIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _BuildCustomAppBar(
        offset: shoppingCartController.hasClients
            ? shoppingCartController.offset
            : 0,
      ),
      body: Stack(
        children: [
          Scrollbar(
            controller: shoppingCartController,
            child: CustomScrollView(
              controller: shoppingCartController,
              slivers: [
                const _BuildTotalInfoWidget(),
                BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
                  buildWhen: (oldState, currentState) {
                    return oldState.shoppingCartProducts.length !=
                            currentState.shoppingCartProducts.length &&
                        currentState.sauces.isNotEmpty;
                  },
                  builder: (context, state) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Column(
                            children: [
                              _BuildShoppingCartItem(index: index),
                              Container(
                                height: 10,
                                color: AppColors.mainBgGrey,
                              ),
                            ],
                          );
                        },
                        childCount: state.shoppingCartProducts.length,
                      ),
                    );
                  },
                ),
                const _BuildAdditionalBlock(),
                const _BuildPromoCodeButton(),
                const _BuildSummeryInfoWidget(),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            right: 0,
            left: 0,
            height: kBottomNavigationBarHeight + 20,
            child: const _BuildBuyBlockWidget(),
          ),
        ],
      ),
    );
  }
}

class _EmptyShoppingCartWidget extends StatelessWidget {
  const _EmptyShoppingCartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppImages.emptyShoppingCartSvg),
        const Text(
          'Ой, пусто!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Ваша корзина пуста, откройте "Меню"\n и выберите понравившися товар.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
          builder: (context, state) {
            if (state.status == OrderType.delivery) {
              return Column(
                children: [
                  Text(
                    'Мы доставим ваш заказ от ${_kMinimalPrice.rubles}',
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        CorporateButton(
          isActive: true,
          onTap: () {
            AutoRouter.of(context).navigate(const MenuRoute());
          },
          child: const Text('Перейти в меню'),
          widthFactor: 0.8,
        )
      ],
    );
  }
}

class _BuildCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final double offset;
  const _BuildCustomAppBar({required this.offset, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(width: 3),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: offset > 5.4
                ? Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
                    Colors.white
                : Colors.white,
            title: const ClipRRect(
              child: Text('Корзина'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _BuildTotalInfoWidget extends StatelessWidget {
  const _BuildTotalInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        top: kMainHorizontalPadding,
        bottom: kMainHorizontalPadding * 2,
      ),
      sliver: SliverToBoxAdapter(
        child: BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
          builder: (context, state) {
            final productsCount = state.shoppingCartProducts.productsCount +
                state.shoppingCartProducts.saucesCount;
            final resultString = '$productsCount ${productsCount.declension(
              'товар',
              'товара',
              'товаров',
            )} на ${(state.productsTotal + state.saucesTotal).toInt().rubles}';
            late final bool atLeastOneUnavailable;
            if (state.orderType == OrderType.restaurant) {
              // TODO(fix): реализовать геттер,который будет брать продукт из блока
              atLeastOneUnavailable = state.shoppingCartProducts
                      .map(
                        (e) =>
                            context
                                .select<MenuBloc, List<Product>>(
                              (value) => value.state.restaurantProducts,
                            )
                                .firstWhereOrNull(
                              (element) {
                                return element.id == e.productId &&
                                    element.restaurantAvailable &&
                                    element.restaurantsToBuy?[
                                            state.addressSelected?.id] ==
                                        null;
                              },
                            ) ==
                            null,
                      )
                      .firstWhereOrNull((element) => element) !=
                  null;
            } else {
              // TODO(fix): реализовать геттер,который будет брать продукт из блока
              atLeastOneUnavailable = state.shoppingCartProducts
                      .map(
                        (e) =>
                            context
                                .select<MenuBloc, List<Product>>(
                                  (value) => value.state.deliverProducts,
                                )
                                .firstWhereOrNull(
                                  (element) =>
                                      element.id == e.productId &&
                                      element.deliverAvailable,
                                ) ==
                            null,
                      )
                      .firstWhereOrNull((element) => element) !=
                  null;
            }
            return Padding(
              padding: EdgeInsets.only(
                left: kMainHorizontalPadding,
                right: kMainHorizontalPadding,
                top: AppBar().preferredSize.height + kToolbarHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resultString,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                  if (state.productsTotal + state.saucesTotal <
                          _kMinimalPrice &&
                      state.orderType == OrderType.delivery)
                    Text(
                      'Минимальная сумма заказа на доставку — ${_kMinimalPrice.rubles}',
                      style: const TextStyle(
                        color: AppColors.mainIconGrey,
                        fontSize: 13,
                      ),
                    ),
                  if (atLeastOneUnavailable) const _BuildUnavailableWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BuildShoppingCartItem extends StatelessWidget {
  final int index;
  const _BuildShoppingCartItem({required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
      builder: (context, state) {
        final cartItem = state.shoppingCartProducts[index];
        late final bool available;
        if (state.orderType == OrderType.restaurant) {
          // TODO(fix): реализовать геттер,который будет брать продукт из блока
          final selectedProduct = context.select<MenuBloc, Product?>(
            (value) => value.state.restaurantProducts.firstWhereOrNull(
              (element) => element.id == cartItem.productId,
            ),
          );
          available = selectedProduct != null &&
              selectedProduct.restaurantAvailable &&
              selectedProduct.restaurantsToBuy != null &&
              state.addressSelected != null &&
              selectedProduct.restaurantsToBuy![state.addressSelected!.id] !=
                  null;
        } else {
          final selectedProduct = context.select<MenuBloc, Product?>(
            (value) => value.state.deliverProducts.firstWhereOrNull(
              (element) => element.id == cartItem.productId,
            ),
          );
          available =
              selectedProduct != null && selectedProduct.deliverAvailable;
        }
        return Dismissible(
          key: ValueKey<String>('shoppingCartItem${cartItem.id}'),
          onDismissed: (dismissDirection) {
            context.read<ShoppingCartCubit>().deleteFromCart(cartItem.id);
          },
          direction: DismissDirection.endToStart,
          background: const ColoredBox(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text(
                  'Удалить',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: kMainHorizontalPadding),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                ListTile(
                  leading: FractionallySizedBox(
                    widthFactor: 0.2,
                    heightFactor: 1.5,
                    child: ProductImageWidget(
                      url: cartItem.image,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    cartItem.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: available
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cartItem.bonusCoinsPrice != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.shopping_bag,
                                    size: 12,
                                    color: AppColors.mainBgOrange,
                                  ),
                                  Text(
                                    'Подарок за ${(cartItem.bonusCoinsPrice?.toInt())!} додокоинов',
                                    style: const TextStyle(
                                      color: AppColors.mainBgOrange,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            Text(
                              cartItem.description,
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        )
                      : const Text(
                          'Не можем добавить',
                          style:
                              TextStyle(fontSize: 12, color: AppColors.mainRed),
                        ),
                ),
                const SizedBox(
                  height: kMainHorizontalPadding,
                ),
                const Divider(
                  indent: kMainHorizontalPadding,
                  endIndent: kMainHorizontalPadding,
                  color: AppColors.mainIconGrey,
                  thickness: 0.2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMainHorizontalPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (available)
                        CartItemPriceWidget(
                          price: cartItem.total.toInt(),
                          oldPrice: cartItem.oldTotal?.toInt(),
                          maxWidth: MediaQuery.of(context).size.width * 0.3,
                        )
                      else
                        const SizedBox.shrink(),
                      if (!available ||
                          (cartItem.productType == ProductType.bonus &&
                              cartItem.count == 1))
                        _BuildDeleteButton(cartItemId: cartItem.id)
                      else
                        BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
                          builder: (context, state) {
                            final availableCoins = context
                                .read<ProfileBloc>()
                                .state
                                .person
                                .dodoCoins;
                            final coinsSpent =
                                state.shoppingCartProducts.coinsSpent;
                            return _BuildItemCountSwitcher(
                              cartItemId: cartItem.id,
                              productsCount: cartItem.count,
                              ableToIncrease: availableCoins - coinsSpent >=
                                  (cartItem.bonusCoinsPrice ?? 0),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kMainHorizontalPadding,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BuildAdditionalBlock extends StatelessWidget {
  const _BuildAdditionalBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kMainHorizontalPadding,
          vertical: kMainHorizontalPadding,
        ),
        decoration: const BoxDecoration(color: AppColors.mainBgGrey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Добавить к заказу?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: kMainHorizontalPadding,
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemExtent: 80,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet<dynamic>(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return SaucesWidget(
                            parentContext: context,
                          );
                        },
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: BlocBuilder<ShoppingCartCubit,
                                ShoppingCartState>(
                              builder: (context, state) {
                                return state.sauces.isEmpty
                                    ? const SizedBox.shrink()
                                    : ProductImageWidget(
                                        url: state.sauces.first.image,
                                      );
                              },
                            ),
                          ),
                          const Expanded(
                            child: Text('Соусы'),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildPromoCodeButton extends StatelessWidget {
  const _BuildPromoCodeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: CorporateButton(
        onTap: () {
          showModalBottomSheet<String>(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            builder: (_) {
              return const _BuildPromoTextFieldWidget();
            },
          );
        },
        isActive: false,
        child: const Text('Ввести промокод'),
        widthFactor: 0.7,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _BuildItemCountSwitcher extends StatelessWidget {
  final int cartItemId;
  final int productsCount;
  final bool ableToIncrease;
  const _BuildItemCountSwitcher({
    required this.productsCount,
    required this.cartItemId,
    required this.ableToIncrease,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context
                  .read<IDodoCloneRepository>()
                  .decreaseShoppingCartItemsCount(cartItemId);
            },
            child: const Icon(
              Icons.remove,
              size: 20,
              color: AppColors.mainIconGrey,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '$productsCount',
            style: const TextStyle(color: AppColors.mainIconGrey),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: ableToIncrease
                ? () {
                    context.read<IDodoCloneRepository>().addProductsToCart(
                          cartItemId: cartItemId,
                        );
                  }
                : null,
            child: Icon(
              Icons.add,
              size: 20,
              color: ableToIncrease
                  ? AppColors.mainIconGrey
                  : AppColors.mainTextGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildSummeryInfoWidget extends StatelessWidget {
  const _BuildSummeryInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
        builder: (context, state) {
          // TODO(fix): why I need to provide toppings all time???
          // final productsTotal = state.shoppingCartProducts
          //     .map(
          //       (e) => e.sectionId != 5
          //           ? context.read<ShoppingCartCubit>().total(e)
          //           : 0,
          //     )
          //     .reduce((value, element) => value + element);
          // final saucesTotal = state.shoppingCartProducts
          //     .map(
          //       (e) => e.sectionId == 5
          //           ? context.read<ShoppingCartCubit>().total(e)
          //           : 0,
          //     )
          //     .reduce((value, element) => value + element);
          final productsCount = state.shoppingCartProducts.productsCount;
          final saucesCount = state.shoppingCartProducts.saucesCount;
          return Padding(
            padding: const EdgeInsets.only(
              right: kMainHorizontalPadding,
              left: kMainHorizontalPadding,
              bottom: kBottomNavigationBarHeight * 2,
            ),
            child: Column(
              children: [
                if (productsCount != 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$productsCount ${productsCount.declension('товар', 'товара', 'товаров')}',
                      ),
                      Text(state.productsTotal.round().rubles),
                    ],
                  ),
                if (saucesCount > 0) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$saucesCount ${saucesCount.declension('соус', 'соуса', 'соусов')}',
                      ),
                      Text(state.saucesTotal.round().rubles),
                    ],
                  ),
                ],
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Начислим додокоинов',
                    ),
                    Text(
                      ((state.productsTotal + state.saucesTotal) / 20)
                          .round()
                          .coins,
                    ),
                  ],
                ),
                if (state.orderType == OrderType.delivery) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Доставка',
                      ),
                      Text('Бесплатно'),
                    ],
                  ),
                ],
                const SizedBox(
                  height: kBottomNavigationBarHeight + 10,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BuildBuyBlockWidget extends StatelessWidget {
  const _BuildBuyBlockWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            border: const Border(
              top: BorderSide(color: Colors.grey, width: 0.3),
              bottom: BorderSide(color: Colors.grey, width: 0.3),
            ),
          ),
          child: Center(
            child: BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
              builder: (context, state) {
                // TODO(fix): need to create total method
                // final price = state.shoppingCartProducts
                //     .map((e) => context.read<ShoppingCartCubit>().total(e))
                //     .reduce((value, element) => value + element);
                final price = state.saucesTotal + state.productsTotal;
                // state.shoppingCartProducts.getTotal
                //     .reduce((value, element) => value + element)
                //     .toInt();
                final isDelivery = state.orderType == OrderType.delivery;
                return CorporateButton(
                  isActive: !(price < _kMinimalPrice && isDelivery),
                  widthFactor: 0.9,
                  child: Text(
                    price < _kMinimalPrice && isDelivery
                        ? 'Добавьте товары на ${(_kMinimalPrice - price).round().rubles}'
                        : 'Оформить заказ за $price ₽',
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildPromoTextFieldWidget extends StatefulWidget {
  const _BuildPromoTextFieldWidget({Key? key}) : super(key: key);

  @override
  State<_BuildPromoTextFieldWidget> createState() =>
      _BuildPromoTextFieldWidgetState();
}

class _BuildPromoTextFieldWidgetState
    extends State<_BuildPromoTextFieldWidget> {
  String promoCode = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (inputText) {
              promoCode = inputText;
            },
            keyboardType: TextInputType.visiblePassword,
            enableSuggestions: false,
            autocorrect: false,
            autofocus: true,
            inputFormatters: [UpperCaseTextFormatter()],
            style: const TextStyle(color: AppColors.mainBgOrange),
            cursorColor: AppColors.mainBgOrange,
            decoration: InputDecoration(
              hintText: 'Введите промокод',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              suffix: TextButton(
                onPressed: () {},
                child: const Text(
                  'Применить',
                  style: TextStyle(color: AppColors.mainBgOrange),
                ),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildShoppingCartIcon extends StatelessWidget {
  const _BuildShoppingCartIcon({
    Key? key,
    required this.selected,
  }) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppIcons.shoppingBag,
          color: selected ? AppColors.mainBgOrange : AppColors.mainIconGrey,
          frameBuilder: (ctx, child, _, __) => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 2,
            ),
            child: child,
          ),
          height: 20,
        ),
        if (selected) ...[
          Positioned(
            top: 4,
            left: 3,
            child: CustomPaint(
              painter: ShoppingBagPizzaSlice(),
              size: const Size(14, 15),
            ),
          ),
          //Draw line
        ]
      ],
    );
  }
}

class _BuildDeleteButton extends StatelessWidget {
  final int cartItemId;
  const _BuildDeleteButton({required this.cartItemId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ShoppingCartCubit>().deleteFromCart(cartItemId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kMainHorizontalPadding,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: AppColors.mainBgGrey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Удалить',
          style: TextStyle(color: AppColors.mainIconGrey),
        ),
      ),
    );
  }
}

class _BuildUnavailableWidget extends StatelessWidget {
  const _BuildUnavailableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: kMainHorizontalPadding),
      padding: const EdgeInsets.all(kMainHorizontalPadding),
      decoration: BoxDecoration(
        color: AppColors.mainBgGrey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(
            Icons.error_outline,
            color: Colors.black,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              'Некоторые продукты разобрали или у нас закончились ингредиенты',
              style: TextStyle(fontSize: 16, overflow: TextOverflow.visible),
            ),
          )
        ],
      ),
    );
  }
}
