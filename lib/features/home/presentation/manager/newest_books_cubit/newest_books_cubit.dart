import 'package:bloc/bloc.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:bookly/features/home/domain/use_cases/fetch_newest_books_use_case.dart';
import 'package:equatable/equatable.dart';

part 'newest_books_state.dart';

class NewestBooksCubit extends Cubit<NewestBooksState> {
  final GetNewestBooksUseCase getNewestBooksUseCase;
  NewestBooksCubit(this.getNewestBooksUseCase) : super(NewestBooksInitial());

  Future<void> fetchNewestBooks({required int pageNumber}) async {
    emit(NewestBooksLoading());
    var result = await getNewestBooksUseCase(pageNumber: pageNumber);
    result.fold(
      (failure) => emit(NewestBooksFailure(failure.errorMessage)),
      (books) => emit(NewestBooksSuccess(books)),
    );
  }
}
