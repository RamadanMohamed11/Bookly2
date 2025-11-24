import 'package:bookly/features/home/data/data_sources/home_local_data_source.dart';
import 'package:bookly/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';

import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repos/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeLocalDataSource homeLocalDataSource;
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRepoImpl({
    required this.homeLocalDataSource,
    required this.homeRemoteDataSource,
  });
  @override
  Future<Either<Failure, List<BookEntity>>> fetchFeaturedBooks({
    required int pageNumber,
  }) async {
    try {
      List<BookEntity> featuredBooks = homeLocalDataSource.fetchFeaturedBooks(
        pageNumber: pageNumber,
      );
      if (featuredBooks.isNotEmpty) {
        return Right(featuredBooks);
      }
      // If local returns empty, check if cache has any data
      // If cache is empty (first launch), fetch from remote
      // If cache has data but this page is empty, we've exhausted local pages
      if (!homeLocalDataSource.hasFeaturedBooksInCache() || pageNumber == 0) {
        featuredBooks = await homeRemoteDataSource.fetchFeaturedBooks(
          pageNumber: pageNumber,
        );
      }
      return Right(featuredBooks);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> fetchNewestBooks({
    required int pageNumber,
  }) async {
    try {
      List<BookEntity> newestBooks = homeLocalDataSource.fetchNewestBooks(
        pageNumber: pageNumber,
      );
      if (newestBooks.isNotEmpty) {
        return Right(newestBooks);
      }
      // If local returns empty, check if cache has any data
      // If cache is empty (first launch), fetch from remote
      // If cache has data but this page is empty, we've exhausted local pages
      if (!homeLocalDataSource.hasNewestBooksInCache() || pageNumber == 0) {
        newestBooks = await homeRemoteDataSource.fetchNewestBooks(
          pageNumber: pageNumber,
        );
      }
      return Right(newestBooks);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
