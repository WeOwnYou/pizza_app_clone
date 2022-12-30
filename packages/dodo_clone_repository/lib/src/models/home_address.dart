import 'package:hive_flutter/hive_flutter.dart';

part 'home_address.g.dart';

@HiveType(typeId: 3)
class HomeAddress {
  @HiveField(0)
  final String street;
  @HiveField(1)
  final String house;
  @HiveField(2)
  final String flat;
  @HiveField(3)
  final String floor;
  @HiveField(4)
  final String doorCode;
  @HiveField(5)
  final String alias;
  @HiveField(6)
  final String comment;

  const HomeAddress({
    required this.street,
    required this.house,
    this.flat = '',
    this.floor = '',
    this.doorCode = '',
    String? alias,
    this.comment = '',
  }) : alias = alias ?? street;
}
