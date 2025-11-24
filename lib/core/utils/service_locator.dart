import 'package:bookly/features/book_details/data/data_sources/book_details_remote_data_source.dart';
import 'package:bookly/features/book_details/domain/repos/book_details_repo.dart';
import 'package:bookly/features/book_details/data/repo/book_details_repo_impl.dart';
import 'package:bookly/features/book_details/domain/use_cases/book_details_use_case.dart';
import 'package:bookly/features/home/data/data_sources/home_local_data_source.dart';
import 'package:bookly/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:bookly/features/home/domain/repos/home_repo.dart';
import 'package:bookly/features/home/domain/use_cases/fetch_featured_books_use_case.dart';
import 'package:bookly/features/home/domain/use_cases/fetch_newest_books_use_case.dart';
import 'package:bookly/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:bookly/features/search/domain/repos/search_repo.dart';
import 'package:bookly/features/search/data/repos/search_repo_impl.dart';
import 'package:bookly/features/search/domain/use_cases/fetch_searched_books_use_case.dart';

import 'api_service.dart';
import '../../features/home/data/repos/home_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<ApiService>(ApiService(getIt.get<Dio>()));
  getIt.registerSingleton<HomeRemoteDataSource>(
    HomeRemoteDataSourceImpl(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<HomeLocalDataSource>(HomeLocalDataSourceImpl());

  getIt.registerSingleton<HomeRepo>(
    HomeRepoImpl(
      homeLocalDataSource: getIt.get<HomeLocalDataSource>(),
      homeRemoteDataSource: getIt.get<HomeRemoteDataSource>(),
    ),
  );

  getIt.registerSingleton<GetNewestBooksUseCase>(
    GetNewestBooksUseCase(getIt.get<HomeRepo>()),
  );
  getIt.registerSingleton<GetFeaturedBooksUseCase>(
    GetFeaturedBooksUseCase(getIt.get<HomeRepo>()),
  );

  getIt.registerSingleton<BookDetailsRemoteDataSource>(
    BookDetailsRemoteDataSourceImpl(getIt.get<ApiService>()),
  );

  getIt.registerSingleton<BookDetailsRepo>(
    BookDetailsRepoImpl(getIt.get<BookDetailsRemoteDataSource>()),
  );

  getIt.registerSingleton<SearchRemoteDataSource>(
    SearchRepoDataSourceImpl(getIt.get<ApiService>()),
  );

  getIt.registerSingleton<SearchRepo>(
    SearchRepoImpl(getIt.get<SearchRemoteDataSource>()),
  );
  getIt.registerSingleton<FetchSearchedBooksUseCase>(
    FetchSearchedBooksUseCase(getIt.get<SearchRepo>()),
  );
  getIt.registerSingleton<BookDetailsUseCase>(
    BookDetailsUseCase(getIt.get<BookDetailsRepo>()),
  );
}
