// import 'models.dart';
// import 'package:pizza_api_client/pizza_api_client.dart' as pizza_api_client;
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
//   factory OrderItem.fromApiClient(pizza_api_client.OrderItem orderItem){
//     return OrderItem(
//       count: orderItem.count,
//       product: Product.fromApiClient(orderItem.product),
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
//
