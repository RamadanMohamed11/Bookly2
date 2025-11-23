import 'package:bloc/bloc.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:bookly/features/home/domain/use_cases/fetch_featured_books_use_case.dart';
import 'package:equatable/equatable.dart';

part 'featured_books_state.dart';

class FeaturedBooksCubit extends Cubit<FeaturedBooksState> {
  final GetFeaturedBooksUseCase getFeaturedBooksUseCase;
  FeaturedBooksCubit(this.getFeaturedBooksUseCase)
    : super(FeaturedBooksInitial());

  Future<void> fetchFeaturedBooks({required int pageNumber}) async {
    emit(FeaturedBooksLoading());
    var result = await getFeaturedBooksUseCase(pageNumber: pageNumber);
    result.fold(
      (failure) => emit(FeaturedBooksFailure(failure.errorMessage)),
      (books) => emit(FeaturedBooksSuccess(books)),
    );
  }
}
