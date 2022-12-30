import 'package:address_repository/address_repository.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart'
    hide OrderType;
import 'package:equatable/equatable.dart';
import 'package:person_repository/person_repository.dart';

enum ShoppingCartStateStatus { initial, empty, hasData, failure }

class ShoppingCartState extends Equatable {
  final OrderType orderType;
  final Address? addressSelected;
  final List<ShoppingCartItem> shoppingCartProducts;
  final List<Product> sauces;
  final List<Topping> toppings;
  final ShoppingCartStateStatus status;

  static ShoppingCartState empty = const ShoppingCartState(
    orderType: OrderType.delivery,
    addressSelected: null,
    shoppingCartProducts: [],
    sauces: [],
    toppings: [],
    status: ShoppingCartStateStatus.initial,
  );

  double get productsTotal => shoppingCartProducts.map((e) => e.sectionId != 5 ? e.price*e.count : 0.0).reduce((value, element) => value+element);
  double get saucesTotal => shoppingCartProducts.map((e) => e.sectionId == 5 ? e.price*e.count : 0.0).reduce((value, element) => value+element);

  @override
  List<Object?> get props => [shoppingCartProducts, addressSelected, orderType, status, sauces];

  const ShoppingCartState({
    required this.orderType,
    required this.addressSelected,
    required this.shoppingCartProducts,
    required this.sauces,
    required this.toppings,
    required this.status,
  });

  ShoppingCartState copyWith({
    OrderType? orderType,
    Address? addressSelected,
    List<ShoppingCartItem>? shoppingCartProducts,
    ShoppingCartStateStatus? status,
    List<Product>? sauces,
    List<Topping>? toppings,
  }) {
    return ShoppingCartState(
      orderType: orderType ?? this.orderType,
      addressSelected: addressSelected ?? this.addressSelected,
      shoppingCartProducts: shoppingCartProducts ?? this.shoppingCartProducts,
      status: status ?? this.status,
      sauces: sauces ?? this.sauces,
      toppings: toppings ?? this.toppings,
    );
  }
}
