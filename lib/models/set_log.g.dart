// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetLogAdapter extends TypeAdapter<SetLog> {
  @override
  final int typeId = 2;

  @override
  SetLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetLog(
      id: fields[0] as String?,
      reps: fields[1] as int,
      weight: fields[2] as double,
      completed: fields[3] as bool,
      restTime: fields[4] as int?,
      rpe: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SetLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.reps)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.restTime)
      ..writeByte(5)
      ..write(obj.rpe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
