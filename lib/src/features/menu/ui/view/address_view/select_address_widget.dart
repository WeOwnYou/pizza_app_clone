import 'package:address_repository/address_repository.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_sizes.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_cubit.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_state.dart';
import 'package:dodo_clone/src/features/menu/bloc/menu_bloc/menu_bloc.dart';
import 'package:dodo_clone/src/features/menu/ui/view/address_view/add_address_view.dart';
import 'package:dodo_clone/src/features/menu/ui/view/address_view/addresses_on_map_view.dart';
import 'package:dodo_clone/src/features/menu/ui/widgets/toggle_button.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectAddressWidget extends StatelessWidget {
  final BuildContext pContext;
  final OrderType orderType;
  const SelectAddressWidget._({
    required this.pContext,
    required this.orderType,
    Key? key,
  }) : super(key: key);

  factory SelectAddressWidget.delivery(
    BuildContext context,
  ) =>
      SelectAddressWidget._(
        pContext: context,
        orderType: OrderType.delivery,
      );

  factory SelectAddressWidget.restaurant(
    BuildContext context,
  ) =>
      SelectAddressWidget._(
        pContext: context,
        orderType: OrderType.restaurant,
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BlocBuilder<AddressCubit, AddressState>(
        bloc: BlocProvider.of<AddressCubit>(pContext),
        builder: (context, state) {
          switch (orderType) {
            case OrderType.delivery:
              return state.deliveryAddresses.isEmpty
                  ? AddAddressFormWidget(parentContext: pContext)
                  : _BuildAddressesListWidget(
                      pContext: pContext,
                      type: OrderType.delivery,
                    );
            case OrderType.restaurant:
              return state.restaurantAddresses.isEmpty
                  // TODO(realise): create and publish here FailureWidget
                  ? Container() // BuildFailureWidget
                  : _BuildAddressesListWidget(
                      pContext: pContext,
                      type: OrderType.restaurant,
                    );
          }
        },
      ),
    );
  }
}

class _BuildAddressesListWidget extends StatefulWidget {
  final BuildContext pContext;
  final OrderType type;
  const _BuildAddressesListWidget({
    required this.pContext,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  State<_BuildAddressesListWidget> createState() =>
      _BuildAddressesListWidgetState();
}

class _BuildAddressesListWidgetState extends State<_BuildAddressesListWidget> {
  late final bool deliverMode;
  int bottomIndex = 0;

  @override
  void initState() {
    super.initState();
    deliverMode = widget.type == OrderType.delivery;
  }

  void _addNewAddress() {
    {
      showModalBottomSheet<Address>(
        useRootNavigator: true,
        isScrollControlled: true,
        context: widget.pContext,
        // TODO(mes): во всех боттомшитах проверить, учитывается ли "челка" телефона
        builder: (context) => AddAddressFormWidget(
          parentContext: widget.pContext,
        ),
      ).then((value) {
        if (value != null) {
          widget.pContext.read<AddressCubit>().updateAddresses(value);
          AppRouter.instance().pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      bloc: BlocProvider.of<AddressCubit>(widget.pContext),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            foregroundColor: Colors.black,
            title: Text(
              deliverMode
                  ? 'Адрес доставки'
                  : (state.selectedCity?.name ?? 'Выберите город'),
            ),
            leadingWidth: MediaQuery.of(context).size.width * 0.2,
            leading: TextButton(
              child: const Text(
                'Назад',
                style: TextStyle(
                  color: AppColors.mainTextOrange,
                  fontSize: 16,
                ),
              ),
              onPressed: Navigator.of(context).pop,
            ),
          ),
          body: IndexedStack(
            index: bottomIndex,
            children: [
              ListView.separated(
                padding: const EdgeInsets.only(left: 5),
                itemCount: deliverMode
                    ? state.deliveryAddresses.length + 1
                    : state.restaurantAddresses.length,
                itemBuilder: (context, index) {
                  if (widget.type == OrderType.delivery &&
                      index == state.deliveryAddresses.length) {
                    return ListTile(
                      minLeadingWidth: 0,
                      title: const Text(
                        'Добавить новый адрес',
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                      trailing: const Icon(
                        Icons.add,
                        color: Colors.orangeAccent,
                      ),
                      onTap: _addNewAddress,
                    );
                  }
                  return deliverMode
                      ? ListTile(
                          onTap: () {
                            widget.pContext
                                .read<AddressCubit>()
                                .changeSelectedAddress(
                                  state.deliveryAddresses[index],
                                );
                            Navigator.of(context).pop();
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.deliveryAddresses[index].addressFormatted,
                              ),
                              if (state.selectedDeliveryAddress ==
                                  state.deliveryAddresses[index])
                                const Icon(
                                  Icons.check,
                                  color: AppColors.mainBgOrange,
                                )
                              else
                                const SizedBox.shrink()
                            ],
                          ),
                        )
                      : ListTile(
                          onTap: () {
                            widget.pContext
                                .read<AddressCubit>()
                                .changeSelectedAddress(
                                  state.restaurantAddresses[index],
                                );
                            widget.pContext
                                .read<MenuBloc>()
                                .add(const MenuUpdateByAddressEvent());
                            Navigator.of(context).pop(true);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.restaurantAddresses[index]
                                    .addressFormatted,
                              ),
                              if (state.selectedRestaurantAddress ==
                                  state.restaurantAddresses[index])
                                const Icon(Icons.check)
                              else
                                const SizedBox.shrink()
                            ],
                          ),
                          subtitle: Text(
                            state.restaurantAddresses[index]
                                .workingHoursFormatted!,
                          ),
                        );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
              AddressesOnMapView(
                addresses: state.restaurantAddresses,
                parentContext: widget.pContext,
              )
            ],
          ),
          bottomNavigationBar: !deliverMode
              ? BottomAppBar(
                  elevation: 0,
                  color: AppColors.mainBgGrey,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: kMainHorizontalPadding,
                      left: kMainHorizontalPadding,
                      right: kMainHorizontalPadding,
                      bottom: kMainHorizontalPadding,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    child: ToggleButton(
                      initialIndex: bottomIndex,
                      choices: const ['Список', 'На карте'],
                      onToggled: (index) {
                        setState(() {
                          bottomIndex = index;
                        });
                      },
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
