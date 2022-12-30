part of 'bonuses_bloc.dart';

enum BonusesStateStatus { loading, success, failure }

class BonusesState extends Equatable {
  final int availableCoins;
  final int numberOfOffersInCart;
  final List<LoyaltyOfferBlock> loyaltyOffers;
  final BonusesStateStatus status;
  final List<CoinsOperation>? coinsOperations;
  const BonusesState({
    required this.availableCoins,
    required this.loyaltyOffers,
    required this.status,
    required this.numberOfOffersInCart,
    this.coinsOperations,
  });

  static const initial = BonusesState(
    availableCoins: 0,
    loyaltyOffers: [],
    status: BonusesStateStatus.loading,
    numberOfOffersInCart: 0,
  );

  BonusesState copyWith({
    int? availableCoins,
    List<LoyaltyOfferBlock>? loyaltyOffers,
    BonusesStateStatus? status,
    int? numberOfOffersInCart,
    List<CoinsOperation>? coinsOperations,
  }) {
    return BonusesState(
      availableCoins: availableCoins ?? this.availableCoins,
      loyaltyOffers: loyaltyOffers ?? this.loyaltyOffers,
      status: status ?? this.status,
      numberOfOffersInCart: numberOfOffersInCart ?? this.numberOfOffersInCart,
      coinsOperations: coinsOperations ?? this.coinsOperations,
    );
  }

  @override
  List<Object?> get props => [
        availableCoins,
        loyaltyOffers,
        status,
        numberOfOffersInCart,
        coinsOperations,
      ];
}
