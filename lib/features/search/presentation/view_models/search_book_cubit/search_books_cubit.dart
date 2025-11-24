import 'package:bloc/bloc.dart';
import 'package:bookly/core/models/book_model/book_model.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:bookly/features/search/domain/repos/search_repo.dart';
import 'package:bookly/features/search/domain/use_cases/fetch_searched_books_use_case.dart';
import 'package:equatable/equatable.dart';

part 'search_books_state.dart';

class SearchBooksCubit extends Cubit<SearchBooksState> {
  final FetchSearchedBooksUseCase fetchSearchedBooksUseCase;
  SearchBooksCubit(this.fetchSearchedBooksUseCase)
    : super(SearchBooksInitial());

  // emit initial state again
  void emitInitial() => emit(SearchBooksInitial());

  Future<void> fetchSearchedBooks({required String searchQuery}) async {
    emit(SearchBooksLoading());
    var result = await fetchSearchedBooksUseCase.call(params: searchQuery);
    result.fold(
      (failure) => emit(SearchBooksInitial()),
      (books) => emit(SearchBooksSuccess(books)),
    );
  }
}
