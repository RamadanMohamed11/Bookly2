import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';
part 'book_entity.g.dart';

@HiveType(typeId: 0)
class BookEntity extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? author;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final DateTime? publishedDate;
  @HiveField(5)
  final String? thumbnail;
  @HiveField(6)
  final int? ratingsCount;
  @HiveField(7)
  final num? averageRating;
  @HiveField(8)
  final List<String>? categories;
  @HiveField(9)
  final String? previewLink;

  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.publishedDate,
    required this.thumbnail,
    required this.ratingsCount,
    required this.averageRating,
    required this.categories,
    required this.previewLink,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    description,
    publishedDate,
    thumbnail,
    ratingsCount,
    averageRating,
    categories,
    previewLink,
  ];
}
