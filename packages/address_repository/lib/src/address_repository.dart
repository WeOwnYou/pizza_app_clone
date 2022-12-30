import 'dart:async';

import 'package:address_repository/address_repository.dart';
import 'package:address_repository/src/completion_service/dadata_address_competion_service.dart';
import 'package:collection/collection.dart';
import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    as dodo_clone_api_client;
// ignore: depend_on_referenced_packages
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_storage_dodo_clone_api/local_storage_dodo_clone_api.dart';

import 'models/models.dart';

class AddressRepository implements IAddressRepository {
  /// API Clients
  final dodo_clone_api_client.IDodoCloneApiClient _dodoCloneApiClient;
  final dodo_clone_api_client.IPersonApiClient _personApiClient;
  final LocalStorageDodoCloneApi _localStorage;

  /// Addresses in App
  List<City> _cities = [];
  City? _selectedCity;
  List<Address> _deliveryAddresses = [];
  List<Address> _restaurantAddresses = [];

  /// Listenable data
  final _cityController = StreamController<City?>.broadcast();
  late Box<int> _cityIdBox;
  // ignore: unused_field
  late ValueListenable<Box<int>> _listenableCityBox;

  @override
  FutureOr<List<City>> get cities async {
    if (_cities.isEmpty) await _loadCities();
    return _cities;
  }

  @override
  City? get selectedCity => _selectedCity;
  @override
  List<Address> get deliveryAddresses => _deliveryAddresses;
  @override
  List<Address> get restaurantAddresses => _restaurantAddresses;

  @override
  Address? get selectedDeliveryAddress =>
      _deliveryAddresses.firstWhereOrNull((element) => element.selected);
  @override
  Address? get selectedRestaurantAddress =>
      _restaurantAddresses.firstWhereOrNull((element) => element.selected);

  AddressRepository({
    required String url,
    dodo_clone_api_client.IDodoCloneApiClient? dodoCloneApiClient,
    dodo_clone_api_client.IPersonApiClient? personApiClient,
    LocalStorageDodoCloneApi? localStorage,
  })  : _dodoCloneApiClient = dodoCloneApiClient ??
            dodo_clone_api_client.DodoCloneApiClient(url: url),
        _personApiClient =
            personApiClient ?? dodo_clone_api_client.PersonApiClient(),
        _localStorage = localStorage ?? LocalStorageDodoCloneApi() {
    _subscribe();
  }

  /// [City] data
  @override
  Stream<City?> get cityStream async* {
    if (_selectedCity == null) await _loadCity();
    yield _selectedCity;
    yield* _cityController.stream;
  }

  Future<void> _loadCity() async {
    final cityId = await _localStorage.hiveProvider.getCityId();
    _selectedCity =
        (await cities).firstWhereOrNull((element) => element.id == cityId);
  }

  @override
  Future<void> changeCity(int cityId) async {
    await _localStorage.hiveProvider.updateCity(cityId);
  }

  Future<void> _loadCities() async {
    final allData = await _dodoCloneApiClient.cities();
    _cities = List<City>.from(allData.result.map<City>(City.fromApiClient));
  }

  Future<void> _subscribe() async {
    _cityIdBox = await _localStorage.hiveProvider.openCityBox();
    _listenableCityBox = _cityIdBox.listenable()
      ..addListener(() async {
        if (_cityIdBox.values.isNotEmpty) {
          await _loadCity();
          _cityController.add(_selectedCity);
        }
      });
  }

  Future<List<Address>> _getAddressesByCity(
    int cityId,
    AddressType type,
  ) async {
    if (_selectedCity == null) {
      type == AddressType.restaurant
          ? _restaurantAddresses.clear()
          : _deliveryAddresses.clear();
    }
    final allData = type == AddressType.restaurant
        ? await _dodoCloneApiClient.addresses(_selectedCity!.id)
        : await _personApiClient.addresses(_selectedCity!.id, 'accessToken');
    final addresses =
        List<Address>.from(allData.result.map<Address>(Address.fromApiClient));
    return addresses;
  }

  @override
  Future<void> updateAddresses() async {
    if (_selectedCity == null) return;
    _deliveryAddresses =
        await _getAddressesByCity(_selectedCity!.id, AddressType.delivery);
    _restaurantAddresses =
        await _getAddressesByCity(_selectedCity!.id, AddressType.restaurant);
  }

  @override
  void changeSelectedAddress(Address address) {
    if (address.type == AddressType.delivery) {
      final prevIndex =
          _deliveryAddresses.indexWhere((element) => element.selected);
      final index =
          _deliveryAddresses.indexWhere((element) => address.id == element.id);
      if (prevIndex >= 0) {
        _deliveryAddresses[prevIndex] =
            _deliveryAddresses[prevIndex].copyWith(selected: false);
      }
      _deliveryAddresses[index] =
          _deliveryAddresses[index].copyWith(selected: true);
    } else {
      final prevIndex =
          _restaurantAddresses.indexWhere((element) => element.selected);
      final index = _restaurantAddresses
          .indexWhere((element) => address.id == element.id);
      if (prevIndex >= 0) {
        _restaurantAddresses[prevIndex] =
            _restaurantAddresses[prevIndex].copyWith(selected: false);
      }
      _restaurantAddresses[index] =
          _restaurantAddresses[index].copyWith(selected: true);
    }
  }

  @override
  Future<void> addAddress(Address address, String accessToken) async {
    assert(_selectedCity == null);
    if (address.type == AddressType.restaurant) {
      throw Exception('CANT ADD RESTAURANT ADDRESS!!!');
    }
    final updatedId = await _personApiClient.addAddress(
      address.toApiClient(),
      'accessToken',
      _selectedCity!.id,
    );
    _deliveryAddresses.add(address.copyWith(id: updatedId));
    changeSelectedAddress(address);
  }

  @override
  Future<List<String>> streetSuggestions({
    required String city,
    required String street,
  }) async {
    final result = await DadataAddressCompletionService.instance
        .getSuggestions('$city $street');
    return result.toSet().toList();
  }

  @override
  void removeAddress(int addressId) {
    _deliveryAddresses.removeWhere((e) => e.id == addressId);
  }

  void dispose() => _cityController.close();

  /// DEV METHODS
  @override
  Future<void> deleteCity() async {
    _selectedCity = null;
    await _localStorage.hiveProvider.deleteCity();
  }
}

abstract class IAddressRepository {
  FutureOr<List<City>> get cities;
  City? get selectedCity;
  Stream<City?> get cityStream;
  Future<void> changeCity(int cityId);
  List<Address> get deliveryAddresses;
  Address? get selectedDeliveryAddress;
  List<Address> get restaurantAddresses;
  Address? get selectedRestaurantAddress;
  Future<void> updateAddresses();
  void changeSelectedAddress(Address address);
  Future<void> addAddress(Address address, String accessToken);
  Future<List<String>> streetSuggestions({
    required String city,
    required String street,
  });
  void removeAddress(int addressId);
  Future<void> deleteCity();
}
