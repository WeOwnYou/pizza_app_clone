import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_storage_dodo_clone_api/src/model/model.dart';

const _kCityBoxName = 'selected_city';
const _kCityKey = 'current_city';

class HiveProvider {
  HiveProvider._();
  static final HiveProvider instance = HiveProvider._();

  Future<Box<LocalStorageShoppingCartItem>> openProductsCartBox() async {
    const boxName = 'shopping_cart';
    if (!Hive.isAdapterRegistered(ProductTypeAdapter().typeId)) {
        Hive.registerAdapter(ProductTypeAdapter());
      }
    if (!Hive.isAdapterRegistered(
        LocalStorageShoppingCartItemAdapter().typeId)) {
      Hive.registerAdapter(LocalStorageShoppingCartItemAdapter());
    }
    // if (!Hive.isAdapterRegistered(LocalStorageProductAdapter().typeId)) {
    //   Hive.registerAdapter(LocalStorageProductAdapter());
    // }
    return Hive.isBoxOpen(boxName)
        ? Hive.box<LocalStorageShoppingCartItem>(boxName)
        : await Hive.openBox<LocalStorageShoppingCartItem>(boxName);
  }

  FutureOr<Box<int>> openCityBox() async {
    return Hive.isBoxOpen(_kCityBoxName)
        ? Hive.box<int>(_kCityBoxName)
        : await Hive.openBox(_kCityBoxName);
  }

  Future<int?> getCityId() async {
    final box = await openCityBox();
    return box.get(_kCityKey);
  }

  Future<void> updateCity(int cityId) async {
    final box = await openCityBox();
    box.put(_kCityKey, cityId);
  }

  Future<void> deleteCity() async {
    final box = await openCityBox();
    box.delete(_kCityKey);
  }

  void closeBox(Box<dynamic> box) {
    box
      ..compact()
      ..close();
  }
}
