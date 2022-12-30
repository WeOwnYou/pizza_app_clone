part 'sections.dart';
part 'ingredients.dart';
part 'offers.dart';
part 'products_details.dart';
part 'product_blocks.dart';
part 'toppings.dart';
part 'stories.dart';
part 'addresses.dart';
part 'person.dart';
part 'orders_history.dart';
part 'promo_codes.dart';
part 'orders.dart';
part 'auth_data.dart';
part 'mock_tokens.dart';
part 'verification_data.dart';
part 'promotions.dart';
part 'loyalty_offers.dart';
part 'coins_history.dart';

class MockData {
  static Map<String, dynamic> stories(int cityId) => mockStories(cityId);
  static const Map<String, dynamic> sections = mockSections;
  static Map<String, dynamic> products(int cityId) =>
      mockProducts(cityId, false);
  static Map<String, dynamic> loyaltyOffers() => mockLoyaltyOffers();
  static Map<String, dynamic> coinsHistory(int personId) =>
      mockCoinsHistory(personId);
  static const Map<String, dynamic> toppings = mockToppings;
  static Map<String, dynamic> productDetails(int productId) =>
      productsDetails(true).firstWhere((element) => element['ID'] == productId);
  static const Map<String, dynamic> ingredients = mockIngredients;

  /// Временно перехватим город, чтобы не создавать mock-данные для всех городов
  static Map<String, dynamic> restaurantAddresses(int cityId) {
    if (cityId != 1 && cityId != 2) {
      cityId = 1;
    }
    return mockRestaurantAddresses(cityId);
  }

  static Map<String, dynamic> deliveryAddresses(
      int cityId, String accessToken) {
    if (cityId != 1 && cityId != 2) {
      cityId = 1;
    }
    return mockDeliveryAddresses(cityId, accessToken);
  }

  static const ingredientsList = mockIngredients;

  static const List offersList = offers;

  /// END OF DODOCLONEAPICLIENT
  /// START PERSON API CLIENT

  static authData(String number) => mockAuthData(number);
  static verificationData(String smsCode) => mockVerificationData(smsCode);
  static getTokensData(String code) => mockGetTokens(code);
  static refreshTokensData(String refreshToken) =>
      mockRefreshTokens(refreshToken);
  static person(String accessToken) => mockPerson(accessToken);
  static ordersHistory(String accessToken) => mockOrdersHistory(accessToken);
  static promotions(int personId) => mockPromotions(personId);
  static missions(int personId) => mockMissions(personId);

  /// В разработке
  static const promoCodesList = promoCodes;
}
