// import 'package:dodo_clone/src/core/domain/entity/address.dart';
// import 'package:dodo_clone/src/core/domain/entity/product.dart';
// import 'package:dodo_clone_repository/dodo_clone_repository.dart' as dodo_clone_repository;
// import 'package:equatable/equatable.dart';
// import 'package:person_repository/person_repository.dart' as person_repository;
//
// enum OrderType { delivery, restaurant, unknown }
//
// class Order extends Equatable {
//   final int orderId;
//   final DateTime orderDate;
//   final OrderType type;
//   final Address address;
//   final List<Product> products;
//   final int total;
//
//   const Order({
//     required this.orderId,
//     required this.orderDate,
//     required this.type,
//     required this.address,
//     required this.products,
//     required this.total,
//   });
//
//   factory Order.fromRepository(
//     person_repository.Order order,
//     List<dodo_clone_repository.Topping>? allToppings,
//   ) {
//     final products = order.products
//         .map((e) => Product.fromPersonRepository(e, allToppings))
//         .toList();
//     var total = 0;
//     products.map((e) => total += e.price.toInt());
//     return Order(
//       orderId: order.id,
//       orderDate: order.dateTime,
//       type: orderTypeFromRepository(order.type),
//       address: Address.fromPersonRepository(order.address),
//       products: products,
//       total: total,
//     );
//   }
//   static OrderType orderTypeFromRepository(person_repository.OrderType type) {
//     if (type.name == 'deliver') {
//       return OrderType.delivery;
//     } else if (type.name == 'restaurant') {
//       return OrderType.restaurant;
//     } else {
//       return OrderType.unknown;
//     }
//   }
//
//   @override
//   List<Object?> get props => [orderId];
// }
