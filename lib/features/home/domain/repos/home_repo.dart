import 'package:bookly/core/errors/failures.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<BookEntity>>> fetchFeaturedBooks({
    required int pageNumber,
  });
  Future<Either<Failure, List<BookEntity>>> fetchNewestBooks({
    required int pageNumber,
  });
}
