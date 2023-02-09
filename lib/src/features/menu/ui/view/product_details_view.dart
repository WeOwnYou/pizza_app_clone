import 'dart:async';
import 'dart:ui';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/int_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/string_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_sizes.dart';
import 'package:dodo_clone/src/core/ui/widgets/product_image_widget.dart';
import 'package:dodo_clone/src/features/menu/bloc/product_details_cubit/product_details_cubit.dart';
import 'package:dodo_clone/src/features/menu/entity/properties.dart';
import 'package:dodo_clone/src/features/menu/ui/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const headerImageSizeFromHeight = 0.3;

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({Key? key}) : super(key: key);

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late final DraggableScrollableController _controller;
  bool needToPop = false;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController()
      ..addListener(() {
        {
          if (_controller.size < 0.3 &&
              Navigator.of(context).canPop() &&
              !needToPop) {
            needToPop = true;
            Navigator.of(context).pop();
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 1,
      snap: true,
      snapSizes: const [1],
      builder: (context, controller) {
        return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            final productOffer = state.product.offers[state.activeOfferIndex];
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Stack(
                  children: [
                    ColoredBox(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView(
                          controller: controller,
                          children: [
                            const SizedBox(
                              height: kToolbarHeight,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  headerImageSizeFromHeight,
                              child: Center(
                                child: (state.product.image.isEmpty)
                                    ? const FlutterLogo(
                                        size: 200,
                                      )
                                    : Transform.scale(
                                        scale: 1 +
                                            state.activeOfferIndex.toDouble() /
                                                10,
                                        child: ProductImageWidget(
                                          url: state.product.image,
                                        ),
                                      ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  productOffer.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const _BuildEnergyValueInfoButton(),
                              ],
                            ),
                            Text(
                              productOffer
                                  .descriptionFormatted(state.activeCrustIndex),
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            RichText(
                              text: TextSpan(
                                children: List.generate(
                                  state.ingredientsList.length,
                                  (index) => TextSpan(
                                    children: [
                                      TextSpan(
                                        text: index == 0
                                            ? state.ingredientsList[index].name
                                                .capitalize()
                                            : state.ingredientsList[index].name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          decoration: state
                                                  .ingredientsList[index]
                                                  .selected
                                              ? TextDecoration.none
                                              : TextDecoration.lineThrough,
                                        ),
                                      ),
                                      if (index !=
                                          state.ingredientsList.length - 1)
                                        const TextSpan(
                                          text: ', ',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (state.ingredientsList.isEmpty)
                              Text(state.product.description),
                            const _BuildPizzaSpecialWidgets(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      height: kBottomNavigationBarHeight + kToolbarHeight,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: ColoredBox(
                            color: Colors.grey.shade200.withOpacity(0.6),
                            child: Center(
                              child: SafeArea(
                                child: FractionallySizedBox(
                                  widthFactor: 0.9,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      final returnedProduct = context
                                          .read<ProductDetailsCubit>()
                                          .addProductToCart();
                                      await AppRouter.instance()
                                          .popTop(returnedProduct);
                                      if (AppRouter.instance().canPop()) {
                                        await AppRouter.instance()
                                            .popTop(returnedProduct);
                                      }
                                    },
                                    child: Text(
                                      'В КОРЗИНУ ЗА ${state.finalPrice.round().rubles}',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 20,
                  top: kToolbarHeight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 3)
                        ],
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: kToolbarHeight,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)],
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.orangeAccent,
                      onPressed: () async {
                        await AppRouter.instance().popTop();
                        unawaited(
                          AppRouter.instance()
                              .navigate(const ShoppingCartRoute()),
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _BuildIngredientsDialogWidget extends StatefulWidget {
  final BuildContext parentContext;
  const _BuildIngredientsDialogWidget(this.parentContext, {Key? key})
      : super(key: key);

  @override
  State<_BuildIngredientsDialogWidget> createState() =>
      _BuildIngredientsDialogWidgetState();
}

class _BuildIngredientsDialogWidgetState
    extends State<_BuildIngredientsDialogWidget> {
  late final List<Ingredient> _currentIngredients;
  late final ProductDetailsCubit _productDetailsCubit;
  @override
  void initState() {
    _productDetailsCubit = widget.parentContext.read<ProductDetailsCubit>();
    _currentIngredients = List.of(_productDetailsCubit.state.ingredientsList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pizza = _productDetailsCubit.state.product;
    return GestureDetector(
      onTap: () {
        AppRouter.instance().popTop();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        primary: false,
        body: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: kMainHorizontalPadding,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kMainBorderRadius),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...(_currentIngredients.isChanged)
                          ? [
                              MaterialButton(
                                onPressed: () {
                                  _productDetailsCubit
                                      .updateIngredients(_currentIngredients);
                                  AppRouter.instance().pop();
                                },
                                child: const Text('Сохранить'),
                                color: Colors.deepOrange,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    kMainBorderRadius,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: widget.parentContext
                                    .read<ProductDetailsCubit>()
                                    .addAllIngredients,
                                child: const Text(
                                  'Сбросить',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            ]
                          : [
                              TextButton(
                                onPressed: () {
                                  AppRouter.instance().pop();
                                },
                                child: const Text(
                                  'Закрыть',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              )
                            ],
                    ],
                  ),
                  ...List.generate(
                    pizza.ingredientsIDs.length,
                    (index) {
                      final selected = _currentIngredients[index].selected;
                      final modifiable = _currentIngredients[index].modifiable;
                      return Padding(
                        padding: const EdgeInsets.only(right: 7.0),
                        child: ChoiceChip(
                          elevation: modifiable ? 0 : 2,
                          selectedColor: Colors.white,
                          selected: selected,
                          onSelected: modifiable
                              ? (_) {
                                  final ingredient = _currentIngredients[index];
                                  setState(() {
                                    _currentIngredients[index] =
                                        ingredient.copyWith(
                                      selected: !ingredient.selected,
                                    );
                                  });
                                }
                              : null,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(kMainBorderRadius),
                            side: BorderSide(
                              color: modifiable
                                  ? Colors.orange
                                  : Colors.grey.shade400,
                              width: 1.5,
                            ),
                          ),
                          label: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: selected ? 4.0 : 14,
                            ),
                            child: Wrap(
                              children: [
                                if (selected && modifiable)
                                  Icon(
                                    key: index == 0 ? widget.key : null,
                                    Icons.close,
                                    color: Colors.orangeAccent,
                                    size: 20,
                                  )
                                else
                                  const SizedBox.shrink(),
                                Text(
                                  _currentIngredients[index].name.capitalize(),
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: modifiable
                                        ? Colors.orange
                                        : Colors.grey,
                                    decoration: selected
                                        ? null
                                        : TextDecoration.lineThrough,
                                    decorationThickness: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildEnergyValueInfoButton extends StatelessWidget {
  const _BuildEnergyValueInfoButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final infoWidgetKey = GlobalKey();
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        return IconButton(
          key: infoWidgetKey,
          icon: const Icon(Icons.error_outline),
          onPressed: () {
            final renderBox =
                infoWidgetKey.currentContext?.findRenderObject() as RenderBox?;
            final infoWidgetPosition = renderBox?.localToGlobal(Offset.zero);
            final infoWidgetSize = renderBox?.size;
            final topPadding =
                infoWidgetPosition!.dy + infoWidgetSize!.height / 2 - 100;
            showGeneralDialog<dynamic>(
              barrierLabel: '',
              barrierColor: Colors.transparent,
              context: context,
              barrierDismissible: true,
              transitionDuration: const Duration(milliseconds: 100),
              transitionBuilder: (ctx, a1, a2, child) => Transform.scale(
                scale: a1.value,
                child: Opacity(
                  opacity: a1.value,
                  child: child,
                ),
              ),
              pageBuilder: (_, __, ___) {
                final energyValueWidgetSize =
                    MediaQuery.of(context).size.width * 0.3;
                return SimpleDialog(
                  alignment: Alignment.topCenter,
                  insetPadding: EdgeInsets.only(
                    top: topPadding < kToolbarHeight
                        ? kToolbarHeight
                        : topPadding,
                    right: infoWidgetSize.width / 1.5,
                  ),
                  backgroundColor: Colors.black.withOpacity(0.75),
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 17,
                  ),
                  title: SizedBox(
                    width: energyValueWidgetSize,
                    child: _BuildEnergyInfoDialogWidget(
                      context: context,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _BuildEnergyInfoDialogWidget extends StatelessWidget {
  final BuildContext context;
  const _BuildEnergyInfoDialogWidget({
    Key? key,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      bloc: BlocProvider.of(this.context),
      builder: (context, state) {
        final offer = state.product.offers[state.activeOfferIndex];
        final energyValue = offer.properties.energyValue;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TextWithPadding(
                offer.name,
              ),
              const _TextWithPadding(
                'Пищевая ценность на 100 г',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _TextWithPadding(
                    'Энерг ценность',
                  ),
                  _TextWithPadding(
                    '${energyValue.calories} ккал',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _TextWithPadding(
                    'Белки',
                  ),
                  _TextWithPadding(
                    '${energyValue.proteins} г',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _TextWithPadding(
                    'Жиры',
                  ),
                  _TextWithPadding(
                    '${energyValue.fats} г',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _TextWithPadding(
                    'Углеводы',
                  ),
                  _TextWithPadding(
                    '${energyValue.carbohydrates} г',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _TextWithPadding(
                    'Вес',
                  ),
                  _TextWithPadding(
                    '${offer.properties.weight} г',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TextWithPadding extends StatelessWidget {
  final String text;
  const _TextWithPadding(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class _BuildPizzaSpecialWidgets extends StatelessWidget {
  const _BuildPizzaSpecialWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        if (state.status != ProductDetailsStateStatus.success) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            if (state.ingredientsList.isNotEmpty)
              TextButton(
                child: const Text('Убрать ингредиенты'),
                onPressed: () {
                  showDialog<dynamic>(
                    context: context,
                    builder: (_) {
                      return _BuildIngredientsDialogWidget(
                        context,
                      );
                    },
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: Colors.orangeAccent,
                ),
              ),
            if (state.product.offers.length > 1)
              ToggleButton(
                onToggled: context.read<ProductDetailsCubit>().changeOffer,
                choices: state.product.offersNames,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 10),
              ),
            if (state.currentOffer.properties.size.crusts != null)
              ToggleButton(
                initialIndex: state.activeCrustIndex,
                onToggled: context.read<ProductDetailsCubit>().changePizzaCrust,
                choices: context.select<ProductDetailsCubit, List<String>>(
                  (value) => value.availableCrusts,
                ),
                height: 40,
              ),
            const SizedBox(
              height: 10,
            ),
            if (state.product.toppingsIDs.isNotEmpty)
              _BuildPizzaToppings(
                availableToppings: state.toppingsList,
              ),
          ],
        );
      },
    );
  }
}

class _BuildPizzaToppings extends StatelessWidget {
  final List<Topping> availableToppings;
  const _BuildPizzaToppings({
    required this.availableToppings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Добавить в пиццу',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          itemCount: availableToppings.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / 4,
            crossAxisCount: 3,
          ),
          itemBuilder: (ctx, index) {
            return _BuildSingleToppingWidget(
              topping: availableToppings[index],
              selected: availableToppings[index].selected,
            );
          },
        ),
        const SizedBox(
          height: kToolbarHeight + kBottomNavigationBarHeight,
        ),
      ],
    );
  }
}

class _BuildSingleToppingWidget extends StatelessWidget {
  final Topping topping;
  final bool selected;
  const _BuildSingleToppingWidget({
    required this.topping,
    required this.selected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        context.read<ProductDetailsCubit>().updateToppingStatus(topping);
      },
      padding: EdgeInsets.zero,
      splashColor: Colors.transparent,
      child: Stack(
        children: [
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: selected ? const EdgeInsets.all(0.5) : EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                border: selected
                    ? Border.all(color: Colors.orange, width: 1.5)
                    : null,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: selected
                    ? null
                    : [BoxShadow(color: Colors.grey.shade400, blurRadius: 5)],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: topping.image.isEmpty
                        ? const FlutterLogo(
                            size: 50,
                          )
                        : ProductImageWidget(url: topping.image),
                  ),
                  Expanded(
                    child: Text(
                      topping.name,
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${topping.price} ₽',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (selected)
            const Positioned(
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.orange,
              ),
              top: 10,
              right: 10,
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
