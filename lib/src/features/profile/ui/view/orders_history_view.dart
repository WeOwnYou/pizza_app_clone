import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/date_time_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/int_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_sizes.dart';
import 'package:dodo_clone/src/core/ui/widgets/corporate_button.dart';
import 'package:dodo_clone/src/core/ui/widgets/product_image_widget.dart';
import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:dodo_clone/src/features/shopping_cart/bloc/shopping_cart_cubit.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const subTitleStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: Colors.black,
);
const titleStyle = TextStyle(
  fontSize: 13,
  color: Colors.grey,
);

class OrdersHistoryView extends StatelessWidget {
  const OrdersHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBgGrey,
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
              const Text('Профиль'),
            ],
          ),
        ),
        title: const Text('История заказов'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status != ProfileStateStatus.success) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.ordersHistory.orders.isEmpty) {
            return const Center(child: _EmptyOrderHistoryWidget());
          }
          return ListView.builder(
            padding: const EdgeInsets.only(
              left: kMainHorizontalPadding,
              right: kMainHorizontalPadding,
              bottom: kBottomNavigationBarHeight + kMainHorizontalPadding,
            ),
            itemCount: state.ordersHistory.orders.length + 1,
            itemBuilder: (context, index) {
              return index != state.ordersHistory.orders.length
                  ? _BuildOrderCardWidget(
                      order: state.ordersHistory.orders[index],
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        left: kMainHorizontalPadding,
                        right: kMainHorizontalPadding,
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                      child: const Text(
                        'Показываются последние 20 заказов за последние 90 дней',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.mainTextGrey),
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}

class _BuildOrderCardWidget extends StatelessWidget {
  final Order order;
  const _BuildOrderCardWidget({required this.order, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.instance().navigate(OrderDetailsRoute(orderId: order.id));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 7,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '№${order.id}',
                style: titleStyle,
              ),
              subtitle: Text(
                order.dateTime.deliveryFormattedDate,
                style: subTitleStyle,
              ),
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
            SizedBox(
              height: 80,
              child: ListView.builder(
                itemExtent: 47,
                itemCount: order.items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ProductImageWidget(
                    url: order.items[index].image,
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(child: Text('Сумма')),
                Expanded(
                  child: Text(
                    order.total.round().rubles,
                  ),
                ),
              ],
            ),
            const Divider(),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.mainBgOrange,
                ),
                child: const Text('Повторить заказ'),
                onPressed: () async {
                  context.read<ProfileBloc>().add(
                        RepeatOrderEvent(order.id),
                      );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _EmptyOrderHistoryWidget extends StatelessWidget {
  const _EmptyOrderHistoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FlutterLogo(
          size: 200,
        ),
        const Text(
          'Ой, пусто!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Здесь будем хранить все ваши заказы.\n Чтобы сделать первый, перейдите в меню.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        CorporateButton(
          isActive: true,
          onTap: () {
            AutoRouter.of(context).navigate(const MenuRouter());
          },
          child: const Text('ПЕРЕЙТИ В МЕНЮ'),
          widthFactor: 0.8,
        )
      ],
    );
  }
}
