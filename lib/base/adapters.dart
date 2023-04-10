// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_classes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppDaylyDataAdapter extends TypeAdapter<AppDaylyData> {
  @override
  final int typeId = 1;

  @override
  AppDaylyData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppDaylyData(
      date: fields[0] as DateTime,
      fat: fields[3] as Fat?,
    )
      ..food = (fields[1] as List)
          .map((dynamic e) => (e as Map).cast<String, int>())
          .toList()
      ..expenditure = (fields[2] as List)
          .map((dynamic e) => (e as Map).cast<String, int>())
          .toList();
  }

  @override
  void write(BinaryWriter writer, AppDaylyData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.food)
      ..writeByte(2)
      ..write(obj.expenditure)
      ..writeByte(3)
      ..write(obj.fat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppDaylyDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FatAdapter extends TypeAdapter<Fat> {
  @override
  final int typeId = 2;

  @override
  Fat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fat(
      fields[0] as double,
      fields[1] as double,
      fields[2] as double,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Fat obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.bodyFatPercentage)
      ..writeByte(1)
      ..write(obj.fatMass)
      ..writeByte(2)
      ..write(obj.massWithoutFat)
      ..writeByte(3)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
