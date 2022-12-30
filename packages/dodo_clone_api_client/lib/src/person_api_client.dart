import 'package:dodo_clone_api_client/src/mock_data/mock_data.dart';
import 'package:dodo_clone_api_client/src/models/models.dart';

const _mockTimerMilliseconds = 300;

class PersonApiClient implements IPersonApiClient {
  @override
  Future<AuthData> sendAuthCode(String number) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = MockData.authData(number);
    return authDataFromJson(allData);
  }

  @override
  Future<VerificationData> verifyNumber(String smsCode) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = MockData.verificationData(smsCode);
    return verificationDataFromJson(allData);
  }

  @override
  Future<Tokens> getTokens(String code) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = MockData.getTokensData(code);
    return tokensFromJson(allData);
  }

  @override
  Future<Tokens> refreshTokens(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = MockData.refreshTokensData(refreshToken);
    return tokensFromJson(allData);
  }

  @override
  Future<Person> person(String accessToken) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = MockData.person(accessToken);
    return personFromJson(allData);
  }

  @override
  Future<Addresses> addresses(int cityId, String accessToken) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = MockData.deliveryAddresses(cityId, accessToken);
    return addressesFromJson(allData, AddressType.deliver);
  }

  @override
  Future<int> addAddress(
      Address address, String accessToken, int cityId) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = await addresses(cityId, accessToken);
    return allData.result.last.id + 7;
  }

  @override
  Future<OrdersHistory> ordersHistory(String accessToken) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = MockData.ordersHistory(accessToken);
    return ordersHistoryFromJson(allData);
  }

  @override
  Future<List<Promotion>> promotions(int personId) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = MockData.promotions(personId);
    return (allData as List<Map<String, dynamic>>)
        .map((e) => promotionFromJson(e))
        .toList();
  }

  @override
  Future<List<Mission>> missions(int personId) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = MockData.missions(personId);
    return (allData as List<Map<String, dynamic>>)
        .map((e) => missionFromJson(e))
        .toList();
  }

  @override
  Future<CoinsOperationsResponse> coinsOperations(int personId) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    Map<String, dynamic> allData = MockData.coinsHistory(personId);
    return coinsOperationsFromJson(allData);
  }
}

abstract class IPersonApiClient {
  Future<AuthData> sendAuthCode(String number);
  Future<VerificationData> verifyNumber(String code);
  Future<Tokens> getTokens(String code);
  Future<Tokens> refreshTokens(String refreshToken);
  Future<Person> person(String accessToken);
  Future<Addresses> addresses(int cityId, String accessToken);
  Future<int> addAddress(Address address, String accessToken, int cityId);
  Future<OrdersHistory> ordersHistory(String accessToken);
  Future<List<Promotion>> promotions(int personId);
  Future<List<Mission>> missions(int personId);
  Future<CoinsOperationsResponse> coinsOperations(int personId);
}
