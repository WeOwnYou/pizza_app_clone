part of 'menu_view.dart';

class _ProductsListBlock extends StatelessWidget {
  const _ProductsListBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (ctx, state) {
        final listProducts = state.orderType == OrderType.delivery
            ? state.deliverProducts
            : state.restaurantProducts;
        return SliverPadding(
          padding: const EdgeInsets.only(
            left: kMainHorizontalPadding,
            right: kMainHorizontalPadding,
            bottom: kBottomNavigationBarHeight * 2,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              listProducts
                  .map<Widget>(
                    (product) => ProductCard.regular(
                      product: product,
                      onItemAddedByPrice: () {
                        context.read<MenuBloc>().add(
                              MenuAddProductToCartEvent(product: product),
                            );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
