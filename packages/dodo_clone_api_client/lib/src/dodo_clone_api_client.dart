import 'dart:core';

import 'package:dio/dio.dart';
import 'package:dodo_clone_api_client/dodo_clone_api_client.dart';
import 'package:dodo_clone_api_client/src/mock_data/mock_data.dart';

const _mockTimerMilliseconds = 300;
//TODO(mes:) NEED TO FIX IT!!!!!
const token = 'dodo_clone';

class DodoCloneApiClient implements IDodoCloneApiClient {
  late final Dio _dio;

  DodoCloneApiClient({required String url})
      : _dio = Dio(BaseOptions(baseUrl: url));

  /// remastered
  @override
  Future<Cities> cities() async {
    final request = await _dio.get('/location/cities');
    final result = citiesFromJson(request.data);
    return result;
  }

  /// remastered
  @override
  Future<Stories> stories(int cityId) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final allData = MockData.stories(cityId);
    return storiesFromJson(allData);
  }

  @override
  Future<Sections> sections() async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    const allData = MockData.sections;
    return sectionsFromJson(allData);
  }

  @override
  Future<Products> products(int cityId) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    Map<String, dynamic> allData = MockData.products(cityId);
    return productsFromJson(allData);
  }

  @override
  Future<LoyaltyOffersResponse> loyaltyOffers(int cityId) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    Map<String, dynamic> allData = MockData.loyaltyOffers();
    return loyaltyOffersFromJson(allData);
  }

  @override
  Future<Product> productDetails(int productId) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final productBlock = MockData.productDetails(productId);
    return Product.fromJson(productBlock);
  }

  @override
  Future<Toppings> toppings() async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    const allData = MockData.toppings;
    return toppingsFromJson(allData);
  }

  @override
  Future<Ingredients> ingredients() async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    const allData = MockData.ingredients;
    return ingredientsFromJson(allData);
  }

  @override
  Future<Addresses> addresses(int cityId) async {
    await Future.delayed(const Duration(milliseconds: _mockTimerMilliseconds));
    final Map<String, dynamic> allData = MockData.restaurantAddresses(cityId);
    return addressesFromJson(allData, AddressType.restaurant);
  }
}

abstract class IDodoCloneApiClient {
  Future<Cities> cities();
  Future<Stories> stories(int cityId);
  Future<Sections> sections();
  Future<Products> products(int cityId);
  Future<LoyaltyOffersResponse> loyaltyOffers(int cityId);
  Future<Product> productDetails(int productId);
  Future<Toppings> toppings();
  Future<Ingredients> ingredients();

  /// Адреса только ресторанов. Адреса доставки в [PersonApiClient]
  Future<Addresses> addresses(int cityId);
}
