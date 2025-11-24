import 'package:bookly/core/errors/failures.dart';
import 'package:bookly/core/utils/api_service.dart';
import 'package:bookly/features/book_details/data/data_sources/book_details_remote_data_source.dart';
import 'package:bookly/features/book_details/domain/repos/book_details_repo.dart';
import 'package:bookly/core/models/book_model/book_model.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class BookDetailsRepoImpl implements BookDetailsRepo {
  final BookDetailsRemoteDataSource bookDetailsRemoteDataSource;
  BookDetailsRepoImpl(this.bookDetailsRemoteDataSource);
  @override
  Future<Either<Failure, List<BookEntity>>> fetchSimilarBooks({
    required String category,
  }) async {
    try {
      List<BookEntity> similarBooks = await bookDetailsRemoteDataSource
          .fetchSimilarBooks(category: category);
      return Right(similarBooks);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
