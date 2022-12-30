import 'package:dodo_clone_api_client/dodo_clone_api_client.dart';

OrdersHistory ordersHistoryFromJson(Map<String, dynamic> json) =>
    OrdersHistory.fromJson(json);

enum OrderType { delivery, restaurant, unknown }

class OrdersHistory {
  final int personId;
  final int ordersTotal;
  final int daysToShow;
  final List<Order> orders;

  const OrdersHistory({
    required this.personId,
    required this.ordersTotal,
    required this.daysToShow,
    required this.orders,
  });

  factory OrdersHistory.fromJson(Map<String, dynamic> json) => OrdersHistory(
        personId: json['person_id'],
        ordersTotal: json['orders_total'],
        daysToShow: json['days_to_show'],
        orders: (json['orders'].cast<Map<String, dynamic>?>())
            .map<Order>((e) => Order.fromJson(e ?? {}))
            .toList(),
      );
}

class Order {
  final int id;
  final DateTime dateTime;
  final OrderType type;
  final Address address;
  final List<ShoppingCartItem> shoppingCartItems;

  const Order({
    required this.id,
    required this.dateTime,
    required this.type,
    required this.address,
    required this.shoppingCartItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final type = calculateOrderType(json['type']);
    return Order(
      id: json['id'],
      dateTime: DateTime.parse(json['date_time']),
      type: calculateOrderType(json['type']),
      address: type == OrderType.restaurant
          ? Address.fromRestaurantJson(json['address'])
          : Address.fromDeliveryJson(json['address']),
      shoppingCartItems: json['shopping_cart']
          .cast<Map<String, dynamic>>()
          .map<ShoppingCartItem>(ShoppingCartItem.fromJson)
          .toList(),
    );
  }

  static OrderType calculateOrderType(String type) {
    if (type == 'deliver') {
      return OrderType.delivery;
    } else if (type == 'restaurant') {
      return OrderType.restaurant;
    } else {
      return OrderType.unknown;
    }
  }
}

class ShoppingCartItem {
  final int id;
  final int count;
  final int total;
  final int productId;
  final int sectionId;
  final String title;
  final String description;
  final String image;
  final double price;
  final int offerId;
  final int? crustId;
  final List<int> ingredientsIDs;
  final List<int> toppingsIDs;

  const ShoppingCartItem({
    required this.id,
    required this.count,
    required this.total,
    required this.productId,
    required this.sectionId,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.offerId,
    this.crustId,
    required this.ingredientsIDs,
    required this.toppingsIDs,
  });

  factory ShoppingCartItem.fromJson(Map<String, dynamic> json) {
    return ShoppingCartItem(
      id: json['id'],
      count: json['count'],
      total: json['total'],
      productId: json['product_id'],
      sectionId: json['section_id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      offerId: json['offer_id'],
      crustId: json['crust_id'],
      ingredientsIDs: (json['ingredients_id_list'] as List<dynamic>).isEmpty ? [] : (json['ingredients_id_list'] as List<int>),
      toppingsIDs: (json['toppings_id_list'] as List<dynamic>).isEmpty ? [] : (json['toppings_id_list'] as List<int>),
    );
  }
}
