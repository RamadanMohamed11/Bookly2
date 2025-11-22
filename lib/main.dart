import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:bookly/features/home/domain/repos/home_repo.dart';
import 'package:bookly/features/home/domain/use_cases/fetch_featured_books_use_case.dart';
import 'package:bookly/features/home/domain/use_cases/fetch_newest_books_use_case.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'constants.dart';
import 'core/utils/app_router.dart';
import 'core/utils/service_locator.dart';
import 'features/home/presentation/manager/featured_books_cubit/featured_books_cubit.dart';
import 'features/home/presentation/manager/newest_books_cubit/newest_books_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  setupServiceLocator();
  await hiveInit();
  runApp(BooklyApp());
}

Future<void> hiveInit() async {
  Hive.registerAdapter(BookEntityAdapter());
  await Hive.initFlutter();
  await Hive.openBox<BookEntity>(kFeaturedBooksBox);
  await Hive.openBox<BookEntity>(kNewestBooksBox);
}

class BooklyApp extends StatelessWidget {
  const BooklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeaturedBooksCubit>(
          create:
              (context) =>
                  FeaturedBooksCubit(getIt.get<GetFeaturedBooksUseCase>())
                    ..fetchFeaturedBooks(),
        ),
        BlocProvider<NewestBooksCubit>(
          create:
              (context) =>
                  NewestBooksCubit(getIt.get<GetNewestBooksUseCase>())
                    ..fetchNewestBooks(),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: GoogleFonts.montserratTextTheme(
            ThemeData.dark().textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
