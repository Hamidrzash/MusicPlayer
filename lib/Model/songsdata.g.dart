// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songs_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackDataAdapter extends TypeAdapter<TrackData> {
  @override
  final int typeId = 0;

  @override
  TrackData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackData(
      fields[0] as String,
      fields[1] as String,
      fields[2] as Uint8List,
      fields[3] as String,
      fields[4] as String,
      fields[5] as int,
    )..isLiked = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, TrackData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.singer)
      ..writeByte(2)
      ..write(obj.cover)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.modified)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.isLiked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
