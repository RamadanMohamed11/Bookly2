import 'package:bookly/core/models/book_model/book_model.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import '../../../../core/utils/api_service.dart';

abstract class HomeRemoteDataSource {
  Future<List<BookEntity>> fetchFeaturedBooks();
  Future<List<BookEntity>> fetchNewestBooks();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;
  HomeRemoteDataSourceImpl(this.apiService);
  @override
  Future<List<BookEntity>> fetchFeaturedBooks() async {
    Map<String, dynamic> data = await apiService.get(
      endPoint:
          'volumes?q=Embedded%20System&Filtering=free-ebooks&Sorting=bestselling',
    );
    List<BookEntity> books = getBooksList(data);
    return books;
  }

  static List<BookEntity> getBooksList(Map<String, dynamic> data) {
    List<BookEntity> books = [];
    for (var e in data['items']) {
      books.add(BookModel.fromJson(e));
    }
    return books;
  }

  @override
  Future<List<BookEntity>> fetchNewestBooks() async {
    Map<String, dynamic> data = await apiService.get(
      endPoint:
          'volumes?q=Computer Science&Filtering=free-ebooks&Sorting=newest',
    );
    List<BookEntity> books = getBooksList(data);
    return books;
  }
}
