import 'package:bookly/core/models/book_model/book_model.dart';
import 'package:bookly/core/utils/api_service.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';

abstract class BookDetailsRemoteDataSource {
  Future<List<BookEntity>> fetchSimilarBooks({required String category});
}

class BookDetailsRemoteDataSourceImpl implements BookDetailsRemoteDataSource {
  final ApiService apiService;
  BookDetailsRemoteDataSourceImpl(this.apiService);
  @override
  Future<List<BookEntity>> fetchSimilarBooks({required String category}) async {
    Map<String, dynamic> data = await apiService.get(
      endPoint: 'volumes?q=$category&Filtering=free-ebooks&Sorting=relevance',
    );
    List<BookEntity> books = [];
    for (var e in data['items']) {
      books.add(BookModel.fromJson(e));
    }
    return books;
  }
}
