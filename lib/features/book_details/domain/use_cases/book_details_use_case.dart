import 'package:bookly/core/errors/failures.dart';
import 'package:bookly/core/use_case/use_case.dart';
import 'package:bookly/features/book_details/domain/repos/book_details_repo.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:dartz/dartz.dart';

class BookDetailsUseCase extends UseCase<List<BookEntity>, String> {
  final BookDetailsRepo bookDetailsRepo;

  BookDetailsUseCase(this.bookDetailsRepo);

  @override
  Future<Either<Failure, List<BookEntity>>> call({
    required String params,
  }) async {
    return await bookDetailsRepo.fetchSimilarBooks(category: params);
  }
}
