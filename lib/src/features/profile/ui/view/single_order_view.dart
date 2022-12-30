import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/date_time_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/int_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_sizes.dart';
import 'package:dodo_clone/src/core/ui/widgets/corporate_button.dart';
import 'package:dodo_clone/src/core/ui/widgets/product_image_widget.dart';
import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:dodo_clone/src/features/profile/ui/view/orders_history_view.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleOrderView extends StatelessWidget {
  final int orderId;
  const SingleOrderView({
    @PathParam('id') required this.orderId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = context
        .read<ProfileBloc>()
        .state
        .ordersHistory
        .orders
        .firstWhere((element) => element.id == orderId);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.30,
        leading: TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.orange),
          onPressed: () {
            context.router.pop();
          },
          child: Row(
            children: [
              Icon(Icons.adaptive.arrow_back),
              const Text('Назад'),
            ],
          ),
        ),
        title: Text('Заказ №$orderId'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kMainHorizontalPadding,
            ),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _BuildOrderItemCardWidget(
                        shoppingCartItem: order.items[index],
                      );
                    },
                    childCount: order.items.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _BuildAdditionalInfoWidget(order: order),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom * 2 +
                        kBottomNavigationBarHeight,
                    //  + MediaQuery.of(context).padding.bottom
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: MediaQuery.of(context).padding.bottom,
            child: ColoredBox(
              color: Colors.white,
              child: Center(
                child: CorporateButton(
                  isActive: true,
                  widthFactor: 0.9,
                  child: const Text('Повторить заказ'),
                  onTap: () async {
                    context.read<ProfileBloc>().add(RepeatOrderEvent(order.id));
                    await AppRouter.instance()
                        .navigate(const ShoppingCartRoute());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildOrderItemCardWidget extends StatelessWidget {
  final ShoppingCartItem shoppingCartItem;
  const _BuildOrderItemCardWidget({required this.shoppingCartItem, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        shoppingCartItem.count,
        (index) => Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ProductImageWidget(
                    url: shoppingCartItem.image,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          shoppingCartItem.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          shoppingCartItem.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.mainTextGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          shoppingCartItem.price.round().rubles,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class _BuildAdditionalInfoWidget extends StatelessWidget {
  final Order order;
  const _BuildAdditionalInfoWidget({required this.order, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Сумма ${order.total.round().rubles}',
              style: subTitleStyle,
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.orange),
              onPressed: () {},
              child: const Text(
                'Чек',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
        const Divider(),
        if (order.type == OrderType.delivery)
          Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Доставка',
                  style: titleStyle,
                ),
                subtitle: Text(
                  order.total >
                          499
                      ? 'Бесплатно'
                      : 'Не бесплатно',
                  style: subTitleStyle,
                ),
              ),
              const Divider(),
            ],
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            order.type == OrderType.restaurant ? 'В зале' : 'На доставку',
            style: titleStyle,
          ),
          subtitle: Text(
            order.address,
            style: subTitleStyle,
          ),
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Время заказа',
            style: titleStyle,
          ),
          subtitle: Text(
            order.dateTime.deliveryFormattedDate,
            style: subTitleStyle,
          ),
        ),
      ],
    );
  }
}
