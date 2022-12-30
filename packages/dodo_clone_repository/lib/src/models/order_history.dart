import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    as dodo_clone_api_client;
import 'package:dodo_clone_repository/dodo_clone_repository.dart';

enum OrderType { delivery, restaurant }

class OrdersHistory {
  final int personId;
  final int total;
  final int daysToShow;
  final List<Order> orders;

  const OrdersHistory({
    required this.personId,
    required this.total,
    required this.daysToShow,
    required this.orders,
  });

  static OrdersHistory empty = const OrdersHistory(personId: 0, orders: [], total: 0, daysToShow: 0);

  factory OrdersHistory.fromApiClient(
          dodo_clone_api_client.OrdersHistory ordersHistory) =>
      OrdersHistory(
        personId: ordersHistory.personId,
        total: ordersHistory.ordersTotal,
        daysToShow: ordersHistory.daysToShow,
        orders: ordersHistory.orders.map(Order.fromApiClient).toList(),
      );
}

class Order {
  final int id;
  final DateTime dateTime;
  final OrderType type;
  final String address;
  final List<ShoppingCartItem> items;

  double get total => items.map((e) => e.price*e.count).reduce((value, element) => value+element);

  // int get total => items
  //     .map((e) => e.total(e.product.toppingList))
  //     .toList()
  //     .reduce((value, element) => value + element)
  //     .round();

  const Order({
    required this.id,
    required this.dateTime,
    required this.type,
    required this.address,
    required this.items,
  });

  factory Order.fromApiClient(dodo_clone_api_client.Order order) {
    final type = calculateOrderType(order.type);
    return Order(
        id: order.id,
        dateTime: order.dateTime,
        type: type,
        address: order.address.toString(),
        items: order.shoppingCartItems.map(ShoppingCartItem.fromApiClient).toList());
  }

  static OrderType calculateOrderType(dodo_clone_api_client.OrderType type) {
    if (type == OrderType.delivery) {
      return OrderType.delivery;
    } else {
      return OrderType.restaurant;
    }
  }
}
