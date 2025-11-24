import 'package:bloc/bloc.dart';
import 'package:bookly/features/book_details/domain/use_cases/book_details_use_case.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:equatable/equatable.dart';

part 'similar_books_state.dart';

class SimilarBooksCubit extends Cubit<SimilarBooksState> {
  final BookDetailsUseCase bookDetailsUseCase;
  SimilarBooksCubit(this.bookDetailsUseCase) : super(SimilarBooksInitial());

  Future<void> fetchSimilarBooks({required String category}) async {
    emit(SimilarBooksLoading());
    var result = await bookDetailsUseCase.call(params: category);
    result.fold(
      (failure) => emit(SimilarBooksFailure(failure.errorMessage)),
      (books) => emit(SimilarBooksSuccess(books)),
    );
  }
}
