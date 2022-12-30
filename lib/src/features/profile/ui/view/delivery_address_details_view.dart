import 'package:address_repository/address_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

const _kTextFieldItems = <String>[
  'Улица',
  'Дом (корпус, строение)',
  'Квартира или офис',
  'Подъезд',
  'Этаж',
  'Код на двери',
  'Название адреса',
  'Комментарий к адресу',
];

class DeliveryAddressDetailsView extends StatelessWidget {
  final Address address;
  const DeliveryAddressDetailsView({required this.address, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.23,
        leading: TextButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.arrow_back_ios_new),
              Text('Назад'),
            ],
          ),
          style: TextButton.styleFrom(foregroundColor: Colors.orange),
          onPressed: AutoRouter.of(context).pop,
        ),
        title: const Text('Адрес доставки'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Удалить'),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: _kTextFieldItems.length,
          itemBuilder: (context, index) {
            return TextFormField(
              initialValue: address.propertyByIndex(index),
              readOnly: true,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: _kTextFieldItems[index],
                labelStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            );
          },),
    );
  }
}
