import 'package:bookly/core/models/book_model/book_model.dart';
import 'package:bookly/core/utils/api_service.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';

abstract class SearchRemoteDataSource {
  Future<List<BookEntity>> fetchSearchedBooks({
    required String query,
    required int pageNumber,
  });
}

class SearchRepoDataSourceImpl implements SearchRemoteDataSource {
  final ApiService apiService;
  SearchRepoDataSourceImpl(this.apiService);
  @override
  Future<List<BookEntity>> fetchSearchedBooks({
    required String query,
    required int pageNumber,
  }) async {
    Map<String, dynamic> data = await apiService.get(
      endPoint:
          'volumes?q=$query&Filtering=free-ebooks&page=${pageNumber * 10}',
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
}
