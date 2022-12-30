import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/core/ui/widgets/bouncing_widget.dart';
import 'package:dodo_clone/src/core/ui/widgets/product_image_widget.dart';
import 'package:dodo_clone/src/features/bonuses/view/bonuses_block_view.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/material.dart';

class ProductCategoryCard extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  final int availableCoins;
  final LoyaltyOfferBlock loyaltyOffersBlock;
  final BuildContext parentContext;
  const ProductCategoryCard({
    Key? key,
    required this.itemHeight,
    required this.itemWidth,
    required this.loyaltyOffersBlock,
    required this.availableCoins, required this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ableToBuy = availableCoins >= loyaltyOffersBlock.coinsPrice;
    return BouncingWidget(
      scaleFactor: 0.7,
      onPressed: () {
        showGeneralDialog(
          context: context,
          barrierColor: Colors.transparent,
          transitionDuration: const Duration(milliseconds: 200),
          transitionBuilder: (context, animation, _, child) {
            const begin = Offset(1.0, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          pageBuilder: (_, __, ___) {
            return BonusesBlockView(
              parentContext: context,
              loyaltyOffersBlock: loyaltyOffersBlock,
              onItemBought: () {},
            );
          },
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: itemHeight * 0.13),
            width: itemWidth,
            height: itemHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(kMainBorderRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(loyaltyOffersBlock.title),
                Padding(
                  padding: EdgeInsets.only(
                    top: itemHeight * 0.07,
                    bottom: itemHeight * 0.13,
                  ),
                  child: Text(
                    '${loyaltyOffersBlock.coinsPrice} D',
                    style: TextStyle(
                      color: ableToBuy && loyaltyOffersBlock.offers.available
                          ? AppColors.mainTextOrange
                          : AppColors.mainTextGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: itemWidth / 4),
            child: ProductImageWidget(
              url: loyaltyOffersBlock.imageUrl,
              width: itemWidth / 2,
              height: itemHeight / 2,
            ),
          ),
        ],
      ),
    );
  }
}
