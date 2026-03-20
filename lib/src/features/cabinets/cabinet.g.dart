// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cabinet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CabinetAdapter extends TypeAdapter<Cabinet> {
  @override
  final int typeId = 1;

  @override
  Cabinet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cabinet(
      id: fields[0] as String?,
      name: fields[1] as String?,
    ).._isSelected = fields[20] as bool?;
  }

  @override
  void write(BinaryWriter writer, Cabinet obj) {
    writer
      ..writeByte(3)
      ..writeByte(20)
      ..write(obj._isSelected)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CabinetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
