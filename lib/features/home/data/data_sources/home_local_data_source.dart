import 'dart:developer';

import 'package:bookly/constants.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:hive_ce/hive.dart';

abstract class HomeLocalDataSource {
  List<BookEntity> fetchFeaturedBooks({required int pageNumber});
  List<BookEntity> fetchNewestBooks({required int pageNumber});
  bool hasFeaturedBooksInCache();
  bool hasNewestBooksInCache();
  int getFeaturedBooksCount();
  int getNewestBooksCount();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  List<BookEntity> fetchFeaturedBooks({required int pageNumber}) {
    int startIndex = pageNumber * 10;
    int endIndex = startIndex + 10;
    var box = Hive.box<BookEntity>(kFeaturedBooksBox);
    if (startIndex >= box.length) {
      return [];
    } else {
      if (endIndex > box.length) {
        endIndex = box.length;
      }
    }
    log('Fetching featured books from index $startIndex to $endIndex');
    return box.values.toList().sublist(startIndex, endIndex);
  }

  @override
  List<BookEntity> fetchNewestBooks({required int pageNumber}) {
    int startIndex = pageNumber * 10;
    int endIndex = startIndex + 10;
    var box = Hive.box<BookEntity>(kNewestBooksBox);
    if (startIndex >= box.length) {
      log('No more books to fetch');
      return [];
    } else {
      if (endIndex > box.length) {
        endIndex = box.length;
      }
    }
    log('Fetching newest books from index $startIndex to $endIndex');
    return box.values.toList().sublist(startIndex, endIndex);
  }

  @override
  bool hasFeaturedBooksInCache() {
    var box = Hive.box<BookEntity>(kFeaturedBooksBox);
    return box.isNotEmpty;
  }

  @override
  bool hasNewestBooksInCache() {
    var box = Hive.box<BookEntity>(kNewestBooksBox);
    return box.isNotEmpty;
  }

  @override
  int getFeaturedBooksCount() {
    var box = Hive.box<BookEntity>(kFeaturedBooksBox);
    return box.length;
  }

  @override
  int getNewestBooksCount() {
    var box = Hive.box<BookEntity>(kNewestBooksBox);
    return box.length;
  }
}
