part of 'menu_view.dart';

class _SpecialProductsBlock extends StatelessWidget {
  const _SpecialProductsBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height *
            MenuConstants.specialBlockFromHeight,
        child: BlocBuilder<MenuBloc, MenuState>(
          builder: (ctx, state) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: kMainHorizontalPadding,
                vertical: 10,
              ),
              itemCount: state.specialProducts.length,
              scrollDirection: Axis.horizontal,
              // itemExtent: MediaQuery.of(context).size.width * 0.6,
              itemBuilder: (context, index) {
                return AspectRatio(
                  aspectRatio: 234 / 104,
                  child: ProductCard.delicious(
                    product: state.specialProducts[index],
                    onItemAddedByPrice: () {
                      context.read<MenuBloc>().add(
                        MenuAddProductToCartEvent(
                          product: state.specialProducts[index],
                          needToAnimate: true,
                        ),
                      );
                    }
                    // onItemAdded: (product, offer)=>context.read<MenuBloc>().add(
                    //   MenuAddProductToCartEvent(
                    //     product: product!,
                    //     needToAnimate: true,
                    //   ),
                    // ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  // void addProductToCart(BuildContext context,{Product? product, Offer? offer}){
  //   assert((product != null)^(offer != null));
  //   context.read<MenuBloc>().add(
  //         MenuAddProductToCartEvent(
  //           product: product!,
  //           needToAnimate: true,
  //         ),
  //       );
  // }
}

class SpecialProductsTitle extends StatelessWidget {
  const SpecialProductsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: kMainHorizontalPadding),
      sliver: SliverToBoxAdapter(
        child: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            return Text(
              state.orderType == OrderType.delivery ? 'Выгодно и вкусно' : 'Вам понравится',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            );
          },
        ),
      ),
    );
  }
}
