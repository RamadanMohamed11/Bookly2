import 'package:bookly/features/home/domain/entities/book_entity.dart';

import 'access_info.dart';
import 'sale_info.dart';
import 'search_info.dart';
import 'volume_info.dart';

class BookModel extends BookEntity {
  final String? kind;
  final String iD;
  final String? etag;
  final String? selfLink;
  final VolumeInfo volumeInfo;
  final SaleInfo? saleInfo;
  final AccessInfo? accessInfo;
  final SearchInfo? searchInfo;

  BookModel({
    this.kind,
    required this.iD,
    this.etag,
    this.selfLink,
    required this.volumeInfo,
    this.saleInfo,
    this.accessInfo,
    this.searchInfo,
  }) : super(
         id: iD,
         title: volumeInfo.title,
         author: volumeInfo.authors?.first,
         description: volumeInfo.description,
         publishedDate: _parsePublishedDate(volumeInfo.publishedDate),
         thumbnail: volumeInfo.imageLinks.thumbnail,
         ratingsCount: volumeInfo.ratingsCount,
         averageRating: volumeInfo.averageRating,
         categories: volumeInfo.categories,
         previewLink: volumeInfo.previewLink,
       );

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    kind: json['kind'] as String?,
    iD: json['id'] as String,
    etag: json['etag'] as String?,
    selfLink: json['selfLink'] as String?,
    volumeInfo: VolumeInfo.fromJson(json['volumeInfo'] as Map<String, dynamic>),
    saleInfo:
        json['saleInfo'] == null
            ? null
            : SaleInfo.fromJson(json['saleInfo'] as Map<String, dynamic>),
    accessInfo:
        json['accessInfo'] == null
            ? null
            : AccessInfo.fromJson(json['accessInfo'] as Map<String, dynamic>),
    searchInfo:
        json['searchInfo'] == null
            ? null
            : SearchInfo.fromJson(json['searchInfo'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'kind': kind,
    'id': id,
    'etag': etag,
    'selfLink': selfLink,
    'volumeInfo': volumeInfo.toJson(),
    'saleInfo': saleInfo?.toJson(),
    'accessInfo': accessInfo?.toJson(),
    'searchInfo': searchInfo?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      ...super.props,
      kind,
      iD,
      etag,
      selfLink,
      volumeInfo,
      saleInfo,
      accessInfo,
      searchInfo,
    ];
  }
}

DateTime? _parsePublishedDate(String? rawDate) {
  if (rawDate == null) {
    return null;
  }

  final trimmed = rawDate.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final normalized = trimmed.replaceAll('/', '-');

  final yearOnly = RegExp(r'^\d{4}$');
  if (yearOnly.hasMatch(normalized)) {
    final year = int.tryParse(normalized);
    return year == null ? null : DateTime(year);
  }

  final yearMonth = RegExp(r'^(\d{4})-(\d{2})$');
  final yearMonthMatch = yearMonth.firstMatch(normalized);
  if (yearMonthMatch != null) {
    final year = int.tryParse(yearMonthMatch.group(1)!);
    final month = int.tryParse(yearMonthMatch.group(2)!);
    if (year != null && month != null && month >= 1 && month <= 12) {
      return DateTime(year, month);
    }
    return null;
  }

  return DateTime.tryParse(normalized);
}
