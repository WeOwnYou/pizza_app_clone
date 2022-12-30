import 'dart:io' show Platform;

import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_cubit.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryAddressesView extends StatelessWidget {
  const DeliveryAddressesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        if (state.deliveryAddresses.isEmpty) {
          AppRouter.instance().popTop();
        }
        return Scaffold(
          appBar: AppBar(
            leadingWidth: MediaQuery.of(context).size.width * 0.26,
            leading: GestureDetector(
              onTap: AutoRouter.of(context).pop,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.orange,
                  ),
                  Text(
                    'Профиль',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            elevation: 0,
            title: const Text('Адреса доставки'),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  AppRouter.instance().push(
                    DeliveryAddressDetailsRoute(
                      address: state.deliveryAddresses[index],
                    ),
                  );
                },
                trailing: Icon(
                  Platform.isIOS ? Icons.arrow_forward_ios : Icons.more_vert,
                  color: Colors.orangeAccent,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.deliveryAddresses[index].alias == null ||
                        state.deliveryAddresses[index].alias!.isEmpty)
                      const SizedBox.shrink()
                    else
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.orangeAccent,
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          state.deliveryAddresses[index].alias ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    Text(
                      '${state.selectedCity!.name}, ${state.deliveryAddresses[index].addressFormatted}',
                    ),
                  ],
                ),
              );
            },
            itemCount: state.deliveryAddresses.length,
          ),
        );
      },
    );
  }
}
