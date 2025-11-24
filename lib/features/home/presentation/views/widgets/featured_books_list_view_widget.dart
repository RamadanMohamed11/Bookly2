import 'package:bookly/features/home/domain/entities/book_entity.dart';

import '../../../../../core/widgets/custom_circular_progress_indicator.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../../../core/widgets/horizontal_books_list_item.dart';
import '../../manager/featured_books_cubit/featured_books_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedBooksListViewWidget extends StatefulWidget {
  const FeaturedBooksListViewWidget({super.key});

  @override
  State<FeaturedBooksListViewWidget> createState() =>
      _FeaturedBooksListViewWidgetState();
}

class _FeaturedBooksListViewWidgetState
    extends State<FeaturedBooksListViewWidget> {
  late ScrollController _horizontalScrollController;
  int featuredPageNumber = 1;
  bool isLoading = false;
  List<BookEntity> booksList = [];

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _horizontalScrollController.addListener(_horizontalScrollListener);
  }

  void _horizontalScrollListener() async {
    if (_horizontalScrollController.position.pixels >=
        _horizontalScrollController.position.maxScrollExtent * 0.7) {
      if (!isLoading) {
        isLoading = true;
        // Fetch more featured books
        await BlocProvider.of<FeaturedBooksCubit>(
          context,
        ).fetchFeaturedBooks(pageNumber: featuredPageNumber);
        featuredPageNumber++;
        isLoading = false;
      }
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.removeListener(_horizontalScrollListener);
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeaturedBooksCubit, FeaturedBooksState>(
      listener: (context, state) {
        if (state is FeaturedBooksSuccess) {
          booksList.addAll(state.books);
        }
      },
      builder: (context, state) {
        if (state is FeaturedBooksSuccess ||
            state is FeaturedBooksLoading ||
            state is FeaturedBooksPaginationLoading) {
          return SizedBox(
            height: 205,
            child: ListView.builder(
              controller: _horizontalScrollController, // Add controller here
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount:
                  state is FeaturedBooksSuccess ? state.books.length : 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right:
                        state is FeaturedBooksSuccess
                            ? (booksList[index] != booksList.last ? 15 : 0)
                            : (index != 9 ? 15 : 0),
                  ),
                  child: HorizontalBooksListItem(
                    imageUrl:
                        state is FeaturedBooksSuccess
                            ? booksList[index].thumbnail!
                            : "",
                    bookEntity:
                        state is FeaturedBooksSuccess ? booksList[index] : null,
                  ),
                );
              },
            ),
          );
        } else if (state is FeaturedBooksFailure) {
          return Center(
            child: CustomErrorWidget(errorMessage: state.errMessage),
          );
        } else {
          return const Center(
            child: Center(child: CustomCircularProgressIndicator()),
          );
        }
      },
    );
  }
}
