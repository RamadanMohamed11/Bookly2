import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'constants.dart';
import 'core/utils/app_router.dart';
import 'core/utils/service_locator.dart';
import 'features/home/data/repos/home_repo.dart';
import 'features/home/presentation/view_models/featured_books_cubit/featured_books_cubit.dart';
import 'features/home/presentation/view_models/newest_books_cubit/newest_books_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  setupServiceLocator();
  Hive.registerAdapter(BookEntityAdapter());
  await Hive.initFlutter();
  await Hive.openBox<BookEntity>(kBooksEntiyBox);
  runApp(BooklyApp());
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
                  FeaturedBooksCubit(getIt.get<HomeRepo>())
                    ..fetchFeaturedBooks(),
        ),
        BlocProvider<NewestBooksCubit>(
          create:
              (context) =>
                  NewestBooksCubit(getIt.get<HomeRepo>())..fetchNewestBooks(),
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
