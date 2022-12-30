part of 'menu_view.dart';

class _OrderDetailsWidget extends StatefulWidget {
  const _OrderDetailsWidget({Key? key}) : super(key: key);

  @override
  State<_OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<_OrderDetailsWidget> {
  int initialIndex = 0;

  void toggleOrderType(int index) {
    setState(() {
      initialIndex = index;
    });
    context.read<MenuBloc>().add(MenuOrderTypeToggleEvent(index));
  }

  Future<bool?> onChangeOrderAddressTap(OrderType orderType) async {
    return PlatformDependentMethod.callFutureByPlatform(
      androidMethod: () => showMaterialModalBottomSheet<bool>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enableDrag: false,
        isDismissible: false,
        useRootNavigator: true,
        expand: true,
        context: context,
        builder: (_) => orderType == OrderType.delivery
            ? SelectAddressWidget.delivery(context)
            : SelectAddressWidget.restaurant(context),
      ),
      iosMethod: () => showCupertinoModalBottomSheet<bool>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enableDrag: false,
        isDismissible: false,
        useRootNavigator: true,
        // expand: true,
        context: context,
        builder: (_) => orderType == OrderType.delivery
            ? SelectAddressWidget.delivery(context)
            : SelectAddressWidget.restaurant(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kMainHorizontalPadding),
        padding: const EdgeInsets.symmetric(horizontal: kMainHorizontalPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kMainBorderRadius),
          color: AppColors.mainBgGrey,
        ),
        child: BlocConsumer<MenuBloc, MenuState>(
          listener: (context, state) {
            final restaurantAddress =
                context.read<AddressCubit>().state.selectedRestaurantAddress;
            if (restaurantAddress == null) {
              onChangeOrderAddressTap(state.orderType).then((value) {
                if (value == null && state.orderType == OrderType.restaurant) {
                  toggleOrderType(0);
                }
              });
            }
          },
          listenWhen: (old, state) {
            return state.orderType == OrderType.restaurant &&
                old.orderType != state.orderType;
          },
          builder: (context, state) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    MenuConstants.addressFromHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ToggleButton(
                    initialIndex: initialIndex,
                    margin: const EdgeInsets.only(
                      top: kMainHorizontalPadding,
                      bottom: kMainHorizontalPadding / 2,
                    ),
                    onToggled: toggleOrderType,
                    choices: const ['На доставку', 'В зале'],
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  if (state.orderType == OrderType.delivery)
                    _BuildAddressWidget.delivery(
                      onTap: onChangeOrderAddressTap,
                      switchOrderType: toggleOrderType,
                    )
                  else
                    _BuildAddressWidget.restaurant(
                      onTap: onChangeOrderAddressTap,
                      switchOrderType: toggleOrderType,
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BuildAddressWidget extends StatelessWidget {
  final OrderType orderType;
  final void Function(OrderType) onTap;
  final void Function(int) switchOrderType;
  const _BuildAddressWidget._({
    required this.orderType,
    required this.onTap,
    required this.switchOrderType,
    Key? key,
  }) : super(key: key);

  factory _BuildAddressWidget.delivery({
    required void Function(OrderType) onTap,
    required void Function(int) switchOrderType,
  }) =>
      _BuildAddressWidget._(
        orderType: OrderType.delivery,
        onTap: onTap,
        switchOrderType: switchOrderType,
      );

  factory _BuildAddressWidget.restaurant({
    required void Function(OrderType) onTap,
    required void Function(int) switchOrderType,
  }) =>
      _BuildAddressWidget._(
        orderType: OrderType.restaurant,
        onTap: onTap,
        switchOrderType: switchOrderType,
      );

  @override
  Widget build(BuildContext context) {
    final deliver = orderType == OrderType.delivery;
    return BlocConsumer<AddressCubit, AddressState>(
      listener: (context, state) {
        switchOrderType(0);
      },
      listenWhen: (old, state) => old.selectedCity != state.selectedCity,
      buildWhen: (oldState, newState) {
        return oldState.selectedDeliveryAddress !=
                newState.selectedDeliveryAddress ||
            oldState.selectedRestaurantAddress !=
                newState.selectedRestaurantAddress;
      },
      builder: (context, state) {
        // if (orderType == OrderType.delivery
        //     ? state.selectedDeliveryAddress == null
        //     : state.selectedRestaurantAddress == null) {
        //   return _BuildAddressEmptyWidget(orderType: orderType);
        // }
        return GestureDetector(
          onTap: () => onTap(orderType),
          child: (deliver
                  ? state.selectedDeliveryAddress == null
                  : state.selectedRestaurantAddress == null)
              ? _BuildAddressEmptyWidget(orderType: orderType)
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          orderType == OrderType.delivery
                              ? Icons.delivery_dining
                              : Icons.fastfood_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        Text(
                          (orderType == OrderType.delivery
                                  ? state
                                      .selectedDeliveryAddress?.addressFormatted
                                  : state.selectedRestaurantAddress
                                      ?.addressFormatted) ??
                              '',
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    if (orderType == OrderType.delivery)
                      const Text(
                        'Бесплатная доставка · Время доставки ~ 123 мин',
                        style: TextStyle(fontSize: 10),
                      ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
        );
      },
    );
  }
}

class _BuildAddressEmptyWidget extends StatelessWidget {
  final OrderType orderType;
  const _BuildAddressEmptyWidget({
    required this.orderType,
  });

  @override
  Widget build(BuildContext context) {
    final deliver = orderType == OrderType.delivery;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Text(
                deliver ? 'Указать адрес доставки' : 'Указать адрес пиццерии',
                style: const TextStyle(color: AppColors.mainTextOrange),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color:
                    deliver ? AppColors.mainTextOrange : AppColors.mainIconGrey,
              ),
            ],
          ),
        )
      ],
    );
  }
}
