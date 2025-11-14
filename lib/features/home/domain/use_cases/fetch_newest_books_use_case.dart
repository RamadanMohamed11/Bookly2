import 'package:bookly/core/errors/failures.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:bookly/features/home/domain/repos/home_repo.dart';
import 'package:dartz/dartz.dart';

class GetNewestBooksUseCase {
  final HomeRepo homeRepo;

  GetNewestBooksUseCase(this.homeRepo);

  Future<Either<Failure, List<BookEntity>>> getNewestBooksUseCase() async {
    return await homeRepo.fetchNewestBooks();
  }
}
