import 'package:dodo_clone/src/core/ui/widgets/price_widget.dart';
import 'package:dodo_clone/src/core/ui/widgets/product_image_widget.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _kMainHorizontalPadding = 15.0;

class SaucesWidget extends StatelessWidget {
  final BuildContext parentContext;
  const SaucesWidget({required this.parentContext, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO(mes): guess I need to remove REPOSITORY from VIEW
    final snapshot = parentContext
        .read<IDodoCloneRepository>()
        .cachedProducts
        .where(
          (element) => element.sectionId == 5,
        )
        .toList();
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: snapshot.length / 10,
      minChildSize: 0.2,
      initialChildSize: snapshot.length / 10,
      builder: (context, controller) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: _kMainHorizontalPadding,
            vertical: _kMainHorizontalPadding,
          ),
          controller: controller,
          itemCount: snapshot.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: ProductImageWidget(
                        url: snapshot[index].image,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(snapshot[index].title),
                    const Spacer(),
                    // TODO(fix): fix repository in view, fix description creation
                    // TODO(mes): добавить недоступность продукта?
                    PriceWidget(
                      active: true,
                      onTap: () => parentContext
                          .read<IDodoCloneRepository>()
                          .addProductsToCart(
                        productsToAdd: [
                          ShoppingCartItem.fromProduct(
                            count: 1,
                            product: snapshot[index],
                            price: snapshot[index].offerPrice,
                          )
                        ],
                      ).then((value) => Navigator.of(context).pop()),
                      price: snapshot[index].selectedOffer.price.round(),
                      isFixed: true,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
