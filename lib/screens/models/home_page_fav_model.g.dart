// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_fav_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomePageFavModelAdapter extends TypeAdapter<HomePageFavModel> {
  @override
  final int typeId = 1;

  @override
  HomePageFavModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomePageFavModel(
      id: fields[0] as int?,
      text: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HomePageFavModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomePageFavModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
