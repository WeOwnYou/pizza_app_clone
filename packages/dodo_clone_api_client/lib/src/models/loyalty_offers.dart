import 'package:dodo_clone_api_client/dodo_clone_api_client.dart';
import 'package:dodo_clone_api_client/src/models/product/product.dart';

LoyaltyOffersResponse loyaltyOffersFromJson(Map<String, dynamic> str) =>
    LoyaltyOffersResponse.fromJson(str);

class LoyaltyOffersResponse {
  final bool error;
  final String message;
  final List<LoyaltyOffers> result;

  const LoyaltyOffersResponse({
    required this.error,
    required this.message,
    required this.result,
  });

  factory LoyaltyOffersResponse.fromJson(Map<String, dynamic> json) =>
      LoyaltyOffersResponse(
        error: json['error'],
        message: json['message'],
        result: List.from(
          (json['result'] as List<Map<String, dynamic>>).map(
            LoyaltyOffers.fromJson,
          ),
        ),
      );
}

class LoyaltyOffers {
  final int coinsPrice;
  final String title;
  final List<Offer> offers;
  final String imageUrl;

  const LoyaltyOffers({
    required this.coinsPrice,
    required this.title,
    required this.offers,
    required this.imageUrl,
  });

  factory LoyaltyOffers.fromJson(Map<String, dynamic> json) => LoyaltyOffers(
        coinsPrice: json['PRICE_COINS'],
        title: json['TITLE'],
        offers: (json['OFFERS'] as List<Map<String, dynamic>>)
            .map(Offer.fromJson)
            .toList(),
        imageUrl: json['PICTURE'],
      );
}
