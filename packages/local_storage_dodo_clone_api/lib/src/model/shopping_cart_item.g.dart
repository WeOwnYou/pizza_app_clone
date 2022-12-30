// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalStorageShoppingCartItemAdapter
    extends TypeAdapter<LocalStorageShoppingCartItem> {
  @override
  final int typeId = 0;

  @override
  LocalStorageShoppingCartItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalStorageShoppingCartItem(
      id: fields[0] as int,
      count: fields[1] as int,
      productId: fields[2] as int,
      sectionId: fields[3] as int,
      title: fields[4] as String,
      description: fields[5] as String,
      image: fields[6] as String,
      price: fields[7] as double,
      offerId: fields[8] as int,
      crustId: fields[9] as int?,
      ingredientsIDs: (fields[10] as List).cast<int>(),
      toppingsIDs: (fields[11] as List).cast<int>(),
      productType: fields[12] as ProductType,
      bonusCoinsPrice: fields[13] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalStorageShoppingCartItem obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.sectionId)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.image)
      ..writeByte(7)
      ..write(obj.price)
      ..writeByte(8)
      ..write(obj.offerId)
      ..writeByte(9)
      ..write(obj.crustId)
      ..writeByte(10)
      ..write(obj.ingredientsIDs)
      ..writeByte(11)
      ..write(obj.toppingsIDs)
      ..writeByte(12)
      ..write(obj.productType)
      ..writeByte(13)
      ..write(obj.bonusCoinsPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalStorageShoppingCartItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductTypeAdapter extends TypeAdapter<ProductType> {
  @override
  final int typeId = 4;

  @override
  ProductType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProductType.regular;
      case 1:
        return ProductType.combo;
      case 2:
        return ProductType.bonus;
      default:
        return ProductType.regular;
    }
  }

  @override
  void write(BinaryWriter writer, ProductType obj) {
    switch (obj) {
      case ProductType.regular:
        writer.writeByte(0);
        break;
      case ProductType.combo:
        writer.writeByte(1);
        break;
      case ProductType.bonus:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
