part of 'bonuses_bloc.dart';

abstract class BonusesEvent extends Equatable {
  const BonusesEvent();
}

class BonusesInitializeEvent extends BonusesEvent {
  final int coinsInCart;
  final int numberOfBonusOffersInCart;
  const BonusesInitializeEvent({
    required this.coinsInCart,
    required this.numberOfBonusOffersInCart,
  });
  @override
  List<Object?> get props => [
        coinsInCart,
        numberOfBonusOffersInCart,
      ];
}

class BonusAddProductToCartEvent extends BonusesEvent {
  final Offer offer;
  final String imageUrl;
  final int coinsPrice;
  const BonusAddProductToCartEvent({
    required this.offer,
    required this.imageUrl,
    required this.coinsPrice,
  });
  @override
  List<Object?> get props => [offer, imageUrl, coinsPrice];
}

class BonusHistoryInitializeEvent extends BonusesEvent {
  const BonusHistoryInitializeEvent();
  @override
  List<Object?> get props => [];
}
