import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'shopping_cart_item.g.dart';

@HiveType(typeId: 4)
enum ProductType {
  @HiveField(0)
  regular,
  @HiveField(1)
  combo,
  @HiveField(2)
  bonus,
}

@HiveType(typeId: 0)
class LocalStorageShoppingCartItem extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int count;
  @HiveField(2)
  final int productId;
  @HiveField(3)
  final int sectionId;
  @HiveField(4)
  final String title;
  @HiveField(5)
  final String description;
  @HiveField(6)
  final String image;
  @HiveField(7)
  final double price;
  @HiveField(8)
  final int offerId;
  @HiveField(9)
  final int? crustId;
  @HiveField(10)
  final List<int> ingredientsIDs;
  @HiveField(11)
  final List<int> toppingsIDs;
  @HiveField(12)
  final ProductType productType;
  @HiveField(13)
  final double? bonusCoinsPrice;

  const LocalStorageShoppingCartItem({
    required this.id,
    required this.count,
    required this.productId,
    required this.sectionId,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.offerId,
    this.crustId,
    required this.ingredientsIDs,
    required this.toppingsIDs,
    required this.productType,
    this.bonusCoinsPrice,
  });

  @override
  List<Object?> get props => [
        productId,
        sectionId,
        title,
        description,
        price,
        offerId,
        crustId,
        ingredientsIDs,
        toppingsIDs,
        productType,
        bonusCoinsPrice,
      ];

  LocalStorageShoppingCartItem copyWith({
    int? id,
    int? count,
    int? productId,
    int? sectionId,
    String? title,
    String? description,
    String? image,
    double? price,
    int? offerId,
    int? crustId,
    List<int>? ingredientsIDs,
    List<int>? toppingsIDs,
    ProductType? productType,
    double? bonusCoinsPrice,
  }) {
    return LocalStorageShoppingCartItem(
      id: id ?? this.id,
      count: count ?? this.count,
      productId: productId ?? this.productId,
      sectionId: sectionId ?? this.sectionId,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      offerId: offerId ?? this.offerId,
      crustId: crustId ?? this.crustId,
      ingredientsIDs: ingredientsIDs ?? this.ingredientsIDs,
      toppingsIDs: toppingsIDs ?? this.toppingsIDs,
      productType: productType ?? this.productType,
      bonusCoinsPrice: bonusCoinsPrice ?? this.bonusCoinsPrice,
    );
  }
}

/*
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_storage_dodo_clone_api/src/model/product.dart';

part 'shopping_cart_item.g.dart';

@HiveType(typeId: 0)
class LocalStorageShoppingCartItem extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final LocalStorageProduct product;
  @HiveField(2)
  final int count;

  const LocalStorageShoppingCartItem({
    required this.id,
    required this.product,
    required this.count,
  });

  LocalStorageShoppingCartItem copyWith({
    int? id,
    LocalStorageProduct? product,
    int? count,
  }) {
    return LocalStorageShoppingCartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [id, count, product];
}

 */
