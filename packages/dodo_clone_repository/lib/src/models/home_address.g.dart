// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_address.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeAddressAdapter extends TypeAdapter<HomeAddress> {
  @override
  final int typeId = 3;

  @override
  HomeAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeAddress(
      street: fields[0] as String,
      house: fields[1] as String,
      flat: fields[2] as String,
      floor: fields[3] as String,
      doorCode: fields[4] as String,
      alias: fields[5] as String?,
      comment: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HomeAddress obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.street)
      ..writeByte(1)
      ..write(obj.house)
      ..writeByte(2)
      ..write(obj.flat)
      ..writeByte(3)
      ..write(obj.floor)
      ..writeByte(4)
      ..write(obj.doorCode)
      ..writeByte(5)
      ..write(obj.alias)
      ..writeByte(6)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
