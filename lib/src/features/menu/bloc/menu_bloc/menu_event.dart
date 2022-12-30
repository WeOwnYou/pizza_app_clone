part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();
}

class MenuInitializeEvent extends MenuEvent {
  final City? city;
  const MenuInitializeEvent(this.city);

  @override
  List<Object?> get props => [];
}

class MenuUpdateByCityEvent extends MenuEvent {
  final City city;

  const MenuUpdateByCityEvent(this.city);

  @override
  List<Object?> get props => [city];
}

class MenuUpdateByAddressEvent extends MenuEvent {
  final OrderType? type;

  const MenuUpdateByAddressEvent({this.type});

  @override
  List<Object?> get props => [];
}

class MenuCategoryChangedEvent extends MenuEvent {
  final int currentIndex;
  final bool manualControl;
  const MenuCategoryChangedEvent(
    this.currentIndex, {
    this.manualControl = false,
  });

  @override
  List<Object?> get props => [currentIndex, manualControl];
}

class MenuEndScrolling extends MenuEvent {
  @override
  List<Object?> get props => [];
}

class MenuStoryWatchedEvent extends MenuEvent {
  final List<int> watchedStories;
  const MenuStoryWatchedEvent(this.watchedStories);
  @override
  List<Object?> get props => [watchedStories];
}

class MenuOrderTypeToggleEvent extends MenuEvent {
  final int index;
  const MenuOrderTypeToggleEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class MenuAddProductToCartEvent extends MenuEvent {
  final Product product;
  final bool needToAnimate;

  const MenuAddProductToCartEvent({
    required this.product,
    this.needToAnimate = false,
  });

  @override
  List<Object?> get props => [product];
}

class MenuEndScrollingAtProduct extends MenuEvent {
  @override
  List<Object?> get props => [];
}

class MenuEndAnimatingProduct extends MenuEvent {
  @override
  List<Object?> get props => [];
}
