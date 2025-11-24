import 'package:bookly/core/errors/failures.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:bookly/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:bookly/features/search/domain/repos/search_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class SearchRepoImpl implements SearchRepo {
  final SearchRemoteDataSource searchRemoteDataSource;
  SearchRepoImpl(this.searchRemoteDataSource);
  @override
  Future<Either<Failure, List<BookEntity>>> fetchSearchedBooks({
    required String searchQuery,
  }) async {
    try {
      List<BookEntity> books = await searchRemoteDataSource.fetchSearchedBooks(
        query: searchQuery,
        pageNumber: 0,
      );
      return Right(books);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
