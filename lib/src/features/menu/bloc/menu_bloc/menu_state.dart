part of 'menu_bloc.dart';

enum MenuStateStatus { initial, loading, success, failure }

class MenuState extends Equatable {
  final MenuStateStatus status;
  final bool menuInAnimation;
  final bool needToAnimateProduct;
  final bool needToScrollAtProduct;
  final OrderType orderType;
  final List<Story> stories;
  final List<Product> specialProducts;
  final int sectionCurrentIndex;
  final List<Section> sections;
  final List<Product> deliverProducts;
  final List<Product> restaurantProducts;
  final int animatedProductIndex;

  const MenuState({
    required this.status,
    required this.menuInAnimation,
    required this.needToAnimateProduct,
    required this.needToScrollAtProduct,
    required this.orderType,
    required this.stories,
    required this.specialProducts,
    required this.sectionCurrentIndex,
    required this.sections,
    required this.deliverProducts,
    required this.restaurantProducts,
    required this.animatedProductIndex,
  });

  static const initial = MenuState(
    status: MenuStateStatus.initial,
    menuInAnimation: false,
    needToAnimateProduct: false,
    needToScrollAtProduct: false,
    orderType: OrderType.delivery,
    stories: [],
    specialProducts: [],
    sectionCurrentIndex: 0,
    sections: [],
    deliverProducts: [],
    restaurantProducts: [],
    animatedProductIndex: 0,
  );

  @override
  List<Object?> get props => [
        status,
        menuInAnimation,
        needToAnimateProduct,
        needToScrollAtProduct,
        orderType,
        stories,
        specialProducts,
        sectionCurrentIndex,
        sections,
        deliverProducts,
        restaurantProducts,
        animatedProductIndex
      ];

  MenuState copyWith({
    MenuStateStatus? status,
    bool? menuInAnimation,
    bool? needToAnimateProduct,
    bool? needToScrollAtProduct,
    OrderType? orderType,
    List<Story>? stories,
    List<Product>? specialProducts,
    int? sectionCurrentIndex,
    List<Section>? sections,
    List<Product>? deliverProducts,
    List<Product>? restaurantProducts,
    int? animatedProductIndex,
  }) {
    return MenuState(
      status: status ?? this.status,
      menuInAnimation: menuInAnimation ?? this.menuInAnimation,
      needToAnimateProduct: needToAnimateProduct ?? this.needToAnimateProduct,
      needToScrollAtProduct:
          needToScrollAtProduct ?? this.needToScrollAtProduct,
      orderType: orderType ?? this.orderType,
      stories: stories ?? this.stories,
      specialProducts: specialProducts ?? this.specialProducts,
      sectionCurrentIndex: sectionCurrentIndex ?? this.sectionCurrentIndex,
      sections: sections ?? this.sections,
      deliverProducts: deliverProducts ?? this.deliverProducts,
      restaurantProducts: restaurantProducts ?? this.restaurantProducts,
      animatedProductIndex: animatedProductIndex ?? this.animatedProductIndex,
    );
  }
}
