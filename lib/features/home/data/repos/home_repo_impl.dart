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
  Future<Either<Failure, List<BookEntity>>> fetchFeaturedBooks() async {
    try {
      List<BookEntity> featuredBooks = homeLocalDataSource.fetchFeaturedBooks();
      if (featuredBooks.isNotEmpty) {
        return Right(featuredBooks);
      }
      featuredBooks = await homeRemoteDataSource.fetchFeaturedBooks();
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
  Future<Either<Failure, List<BookEntity>>> fetchNewestBooks() async {
    try {
      List<BookEntity> newestBooks = homeLocalDataSource.fetchNewestBooks();
      if (newestBooks.isNotEmpty) {
        return Right(newestBooks);
      }
      newestBooks = await homeRemoteDataSource.fetchNewestBooks();
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
