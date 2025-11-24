import 'package:bookly/core/errors/failures.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BookDetailsRepo {
  Future<Either<Failure, List<BookEntity>>> fetchSimilarBooks({
    required String category,
  });
}
