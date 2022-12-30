// import 'package:equatable/equatable.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
// part 'product.g.dart';
//
// @HiveType(typeId: 1)
// class LocalStorageProduct extends Equatable {
//   @HiveField(0)
//   final int categoryId;
//   @HiveField(1)
//   final int id;
//   @HiveField(2)
//   final String title;
//   @HiveField(3)
//   final String image;
//   @HiveField(4)
//   final String description;
//   @HiveField(5)
//   final int offerID;
//   @HiveField(6)
//   final int? crustID;
//   @HiveField(7)
//   final List<int> ingredientsIDs;
//   @HiveField(8)
//   final List<int> toppingsIDs;
//
//   const LocalStorageProduct({
//     required this.categoryId,
//     required this.id,
//     required this.title,
//     required this.image,
//     required this.description,
//     required this.offerID,
//     this.crustID,
//     required this.ingredientsIDs,
//     required this.toppingsIDs,
//   });
//
//   @override
//   List<Object?> get props => [
//         categoryId,
//         id,
//         title,
//         image,
//         description,
//         offerID,
//         crustID,
//         ingredientsIDs,
//         toppingsIDs,
//       ];
//
//   LocalStorageProduct copyWith({
//     int? categoryId,
//     int? id,
//     String? title,
//     String? image,
//     String? description,
//     int? offerID,
//     int? crustID,
//     List<int>? ingredientsIDs,
//     List<int>? toppingsIDs,
//   }) {
//     return LocalStorageProduct(
//       categoryId: categoryId ?? this.categoryId,
//       id: id ?? this.id,
//       title: title ?? this.title,
//       image: image ?? this.image,
//       description: description ?? this.description,
//       offerID: offerID ?? this.offerID,
//       crustID: crustID ?? this.crustID,
//       ingredientsIDs: ingredientsIDs ?? this.ingredientsIDs,
//       toppingsIDs: toppingsIDs ?? this.toppingsIDs,
//     );
//   }
// }
