import 'dart:async';

import 'package:badges/badges.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:dodo_clone/src/core/ui/widgets/price_widget.dart';
import 'package:dodo_clone/src/core/ui/widgets/product_image_widget.dart';
import 'package:dodo_clone/src/features/menu/bloc/menu_bloc/menu_bloc.dart';
import 'package:dodo_clone/src/features/menu/bloc/product_details_cubit/product_details_cubit.dart';
import 'package:dodo_clone/src/features/menu/ui/menu_export.dart';
import 'package:dodo_clone/src/features/menu/ui/utils/constants.dart';
import 'package:dodo_clone/src/features/menu/ui/view/product_details_view.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCard extends StatelessWidget {
  ///Null при добавлении из бонусов
  final Product? product;
  final String title;
  final int price;
  final String description;
  final bool isHit;
  final String image;
  final bool specialBlock;
  final bool needToAnimate;
  final bool ableToBuy;

  ///false только в [SearchView]
  final bool? immutableProduct;

  ///Используется для добавления виджета по цене (menu, delicious, bonuses),
  ///null если добавить по цене невозможно (search).
  final VoidCallback? onAddItemByPrice;
  factory ProductCard.delicious({
    required Product product,
    required VoidCallback onItemAddedByPrice,
  }) =>
      ProductCard._(
        product: product,
        title: product.title,
        price: product.selectedOffer.price.round(),
        description: product.description,
        isHit: product.isHit ?? false,
        image: product.image,
        needToAnimate: true,
        specialBlock: true,
        //product.able(product.selectedOffer.able)
        ableToBuy: true,
        onAddItemByPrice: onItemAddedByPrice,
      );

  const ProductCard._({
    this.product,
    required this.price,
    required this.description,
    required this.isHit,
    required this.image,
    required this.title,
    this.immutableProduct,
    this.specialBlock = false,
    this.needToAnimate = false,
    required this.ableToBuy,
    this.onAddItemByPrice,
    Key? key,
  }) : super(key: key);
  factory ProductCard.searched({
    required Product product,
  }) =>
      ProductCard._(
        product: product,
        title: product.title,
        description: product.description,
        price: product.selectedOffer.price.round(),
        isHit: product.isHit ?? false,
        image: product.image,
        //product.able(product.selectedOffer.able)
        ableToBuy: true,
        immutableProduct: false,
        needToAnimate: true,
      );
  factory ProductCard.regular({
    required Product product,
    required VoidCallback onItemAddedByPrice,
  }) =>
      ProductCard._(
        product: product,
        title: product.title,
        description: product.description,
        price: product.selectedOffer.price.round(),
        isHit: product.isHit ?? false,
        image: product.image,
        //product.able(product.selectedOffer.able),
        ableToBuy: true,
        onAddItemByPrice: onItemAddedByPrice,
      );
  factory ProductCard.bonuses({
    required Offer offer,
    required String imageUrl,
    required int price,
    required bool ableToBuy,
    required VoidCallback onItemAdded,
  }) =>
      ProductCard._(
        title: offer.name,
        description: offer.description ?? offer.descriptionFormatted(),

        ///если офер не доступен
        price: offer.available ? price : -1,
        isHit: false,
        ableToBuy: ableToBuy && offer.available,
        image: imageUrl,
        onAddItemByPrice: onItemAdded,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: product == null
          ? null
          : () {
              showModalBottomSheet<Product?>(
                barrierColor: Colors.transparent,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) {
                  return BlocProvider<ProductDetailsCubit>(
                    create: (ctx) => ProductDetailsCubit(
                      product: product!,
                      dodoCloneRepository: context.read<IDodoCloneRepository>(),
                    ),
                    child: const ProductDetailsView(),
                  );
                },
                useRootNavigator: true,
              ).then<Product?>((value) async {
                if (value == null) return;
                await Future<dynamic>.delayed(const Duration(milliseconds: 300),
                    () {
                  context.read<MenuBloc>().add(
                        MenuAddProductToCartEvent(
                          product: value,
                          needToAnimate: needToAnimate,
                        ),
                      );
                });

                return null;
              });
            },
      child: Container(
        height: MenuConstants.productHeight,
        margin: specialBlock ? const EdgeInsets.symmetric(horizontal: 5) : null,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: specialBlock
              ? [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 0.5,
                    blurRadius: 10,
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Badge(
                showBadge: isHit,
                position: specialBlock
                    ? BadgePosition.topEnd(top: 1, end: 1)
                    : BadgePosition.topEnd(end: 25),
                shape: BadgeShape.square,
                borderRadius:
                    const BorderRadius.all(Radius.elliptical(100, 50)),
                badgeContent: const Text(
                  'Hit!!!',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                badgeColor: Colors.yellow,
                child: ProductImageWidget(
                  url: image,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (specialBlock)
                      Text(
                        title,
                        style: const TextStyle(fontSize: 12),
                      )
                    else
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (!specialBlock) ...[
                      Text(
                        description,
                        maxLines: 7,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.mainIconGrey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    PriceWidget(
                      active: ableToBuy,
                      price: price,
                      isFixed: product?.immutable ?? true,
                      isRubles: product != null,
                      onTap: (immutableProduct ?? (product?.immutable ?? true))
                          ? onAddItemByPrice
                          : null,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
