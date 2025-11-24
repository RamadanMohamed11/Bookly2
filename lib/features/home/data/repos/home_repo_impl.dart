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
      // If local returns empty, check if we need to fetch from remote:
      // 1. Cache is completely empty (first launch) - fetch from remote
      // 2. The requested page index is beyond what we have in cache - fetch from remote
      int cacheCount = homeLocalDataSource.getFeaturedBooksCount();
      int requiredIndex = pageNumber * 10;

      if (!homeLocalDataSource.hasFeaturedBooksInCache() ||
          requiredIndex >= cacheCount) {
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
      // If local returns empty, check if we need to fetch from remote:
      // 1. Cache is completely empty (first launch) - fetch from remote
      // 2. The requested page index is beyond what we have in cache - fetch from remote
      int cacheCount = homeLocalDataSource.getNewestBooksCount();
      int requiredIndex = pageNumber * 10;

      if (!homeLocalDataSource.hasNewestBooksInCache() ||
          requiredIndex >= cacheCount) {
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
