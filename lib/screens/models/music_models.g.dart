// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MixMusicModelAdapter extends TypeAdapter<MixMusicModel> {
  @override
  final int typeId = 10;

  @override
  MixMusicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MixMusicModel(
      first: fields[1] as MusicModel?,
      second: fields[2] as MusicModel?,
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MixMusicModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.first)
      ..writeByte(2)
      ..write(obj.second);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MixMusicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MusicModelAdapter extends TypeAdapter<MusicModel> {
  @override
  final int typeId = 0;

  @override
  MusicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicModel(
      musicName: fields[0] as String,
      musicFile: fields[1] as String,
      id: fields[2] as String,
      image: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MusicModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.musicName)
      ..writeByte(1)
      ..write(obj.musicFile)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
