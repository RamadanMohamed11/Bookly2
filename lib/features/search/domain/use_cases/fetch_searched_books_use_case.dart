import 'package:bookly/core/errors/failures.dart';
import 'package:bookly/core/use_case/use_case.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:bookly/features/search/domain/repos/search_repo.dart';
import 'package:dartz/dartz.dart';

class FetchSearchedBooksUseCase extends UseCase<List<BookEntity>, String> {
  final SearchRepo searchRepo;

  FetchSearchedBooksUseCase(this.searchRepo);

  @override
  Future<Either<Failure, List<BookEntity>>> call({
    required String params,
  }) async {
    return await searchRepo.fetchSearchedBooks(searchQuery: params);
  }
}
