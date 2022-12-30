import 'dart:math';

import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/features/bonuses/bloc/bonuses_bloc.dart';
import 'package:dodo_clone/src/features/menu/ui/widgets/product_card.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _kMainExtentCoefficient = 0.25;

///View for android
class BonusesBlockView extends StatefulWidget {
  final Function onItemBought;
  final BuildContext parentContext;
  final LoyaltyOfferBlock loyaltyOffersBlock;

  const BonusesBlockView({
    Key? key,
    required this.onItemBought,
    required this.loyaltyOffersBlock,
    required this.parentContext,
  }) : super(key: key);

  @override
  State<BonusesBlockView> createState() => _BonusesBlockViewState();
}

class _BonusesBlockViewState extends State<BonusesBlockView> {
  OverlayEntry? _overlayEntry;
  void showOverlay(BuildContext context) {
    _overlayEntry?.remove();
    final overlayState = Overlay.of(context);
    final overlayWidth = MediaQuery.of(context).size.width * 0.9;
    _overlayEntry = OverlayEntry(
      builder: (ctx) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 25),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.black.withOpacity(0.85),
          width: overlayWidth,
          height: overlayWidth * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '1 товар добавлен',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: AppColors.orangeRed,
                ),
                onPressed: () async {
                  _overlayEntry?.remove();
                  while (AppRouter.instance().canPop()) {
                    await AppRouter.instance().popTop();
                  }
                  await AppRouter.instance()
                      .navigate(const ShoppingCartRoute());
                },
                child: const Text(
                  'В корзину',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mainTextOrange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    overlayState?.insert(_overlayEntry!);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (_overlayEntry?.mounted ?? false) {
        _overlayEntry!.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImages.splashImage,
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.mainBluePurple,
                  AppColors.bgLightOrange.withOpacity(0.93),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.54, 0.9],
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: BonusesGroupHeader(
                  maxExtent: MediaQuery.of(context).size.height *
                      _kMainExtentCoefficient,
                  minExtent: MediaQuery.of(context).size.height * 0.11,
                  title: widget.loyaltyOffersBlock.title,
                  price: widget.loyaltyOffersBlock.coinsPrice,
                  parentContext: widget.parentContext,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, index) {
                    final offer = widget.loyaltyOffersBlock.offers[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                        left: 8,
                        right: 8,
                      ),
                      child: BlocBuilder<BonusesBloc, BonusesState>(
                        bloc: BlocProvider.of(widget.parentContext),
                        builder: (context, state) {
                          return ProductCard.bonuses(
                            ableToBuy: state.availableCoins >=
                                widget.loyaltyOffersBlock.coinsPrice,
                            offer: offer,
                            imageUrl: offer.image,
                            price: widget.loyaltyOffersBlock.coinsPrice,
                            onItemAdded: () {
                              showOverlay(context);
                              widget.parentContext.read<BonusesBloc>().add(
                                    BonusAddProductToCartEvent(
                                      coinsPrice:
                                          widget.loyaltyOffersBlock.coinsPrice,
                                      imageUrl:
                                          widget.loyaltyOffersBlock.imageUrl,
                                      offer: offer,
                                    ),
                                  );
                            },
                          );
                        },
                      ),
                    );
                  },
                  childCount: widget.loyaltyOffersBlock.offers.length,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BonusesGroupHeader extends SliverPersistentHeaderDelegate {
  @override
  final double maxExtent;
  @override
  final double minExtent;
  final String title;
  final int price;
  final BuildContext parentContext;
  const BonusesGroupHeader({
    required this.maxExtent,
    required this.minExtent,
    required this.title,
    required this.price,
    required this.parentContext,
  });
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    ///после достижения 0,55 прогресс останавливается
    final formattedShrinkOffset =
        (shrinkOffset < 0.55 * maxExtent) ? shrinkOffset : 0.55 * maxExtent;
    final progress = formattedShrinkOffset / maxExtent;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<BonusesBloc, BonusesState>(
      bloc: BlocProvider.of(parentContext),
      builder: (context, state) {
        return DecoratedBox(
          decoration: const BoxDecoration(color: AppColors.mainBluePurple),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  //перемещение тайтла засчет изменения падингов
                  margin: EdgeInsets.only(
                    left: progress * width * 0.15,
                    bottom: max(
                      (maxExtent - formattedShrinkOffset) * 0.17,
                      minExtent * 0.2,
                    ),
                  ),
                  width: max((1 - progress) * width, width * 0.4), //title width
                  height: max(
                    (1 - progress) * maxExtent * _kMainExtentCoefficient,
                    minExtent * _kMainExtentCoefficient,
                  ), //title height
                  child: FittedBox(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: maxExtent * (progress / 3 + 0.8),
                ),
                child: Center(
                  child: Text(
                    price <= state.availableCoins
                        ? 'За $price коинов и 1 рубль'
                        : 'Не хватает ${price - state.availableCoins} коинов',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  child: IconButton(
                    splashRadius: 3,
                    onPressed: AppRouter.instance().popTop,
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: minExtent * 0.3,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '${state.availableCoins} D',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
