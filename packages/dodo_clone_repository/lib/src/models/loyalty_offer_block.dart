import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    as dodo_clone_api_client;
import 'package:dodo_clone_repository/src/models/product/product.dart';

class LoyaltyOfferBlock {
  final int coinsPrice;
  final String title;
  final List<Offer> offers;
  final String imageUrl;

  const LoyaltyOfferBlock({
    required this.coinsPrice,
    required this.title,
    required this.offers,
    required this.imageUrl,
  });

  LoyaltyOfferBlock copyWith({List<Offer>? offers}) {
    if(offers == null || offers == this.offers) return this;
    return LoyaltyOfferBlock(
      coinsPrice: coinsPrice,
      title: title,
      offers: offers,
      imageUrl: imageUrl,
    );
  }

  factory LoyaltyOfferBlock.fromApiClient(
      dodo_clone_api_client.LoyaltyOffers loyaltyOffers) {
    return LoyaltyOfferBlock(
      coinsPrice: loyaltyOffers.coinsPrice,
      title: loyaltyOffers.title,
      offers: loyaltyOffers.offers.map(Offer.fromApiClient).toList(),
      imageUrl: loyaltyOffers.imageUrl,
    );
  }
}
