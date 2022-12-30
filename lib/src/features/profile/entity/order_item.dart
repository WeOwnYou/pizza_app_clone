// import 'package:dodo_clone_repository/dodo_clone_repository.dart';
// import 'package:person_repository/person_repository.dart' as person_repository;
//
//
// class OrderItem {
//   final int count;
//   final Product product;
//   final String title;
//   final num total;
//
//   const OrderItem({
//     required this.title,
//     required this.count,
//     required this.product,
//     required this.total,
//   });
//
//   factory OrderItem.fromRepository(person_repository.OrderItem orderItem){
//     return OrderItem(
//       count: orderItem.count,
//       product: Product.fromPersonRepository(orderItem.product),
//       title: orderItem.title,
//       total: orderItem.total,
//     );
//   }
//
//   OrderItem copyWith({
//     int? count,
//     Product? product,
//     String? title,
//     num? total,
//   }) {
//     return OrderItem(
//       count: count ?? this.count,
//       product: product ?? this.product,
//       title: title ?? this.title,
//       total: total ?? this.total,
//     );
//   }
// }
