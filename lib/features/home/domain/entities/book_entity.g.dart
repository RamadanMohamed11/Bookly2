// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookEntityAdapter extends TypeAdapter<BookEntity> {
  @override
  final typeId = 0;

  @override
  BookEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookEntity(
      id: fields[0] as String,
      title: fields[1] as String,
      author: fields[2] as String?,
      description: fields[3] as String?,
      publishedDate: fields[4] as DateTime?,
      thumbnail: fields[5] as String?,
      ratingsCount: (fields[6] as num?)?.toInt(),
      averageRating: fields[7] as num?,
      categories: (fields[8] as List?)?.cast<String>(),
      previewLink: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookEntity obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.publishedDate)
      ..writeByte(5)
      ..write(obj.thumbnail)
      ..writeByte(6)
      ..write(obj.ratingsCount)
      ..writeByte(7)
      ..write(obj.averageRating)
      ..writeByte(8)
      ..write(obj.categories)
      ..writeByte(9)
      ..write(obj.previewLink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
