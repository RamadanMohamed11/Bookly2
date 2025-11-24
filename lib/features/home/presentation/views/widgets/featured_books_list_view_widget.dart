import 'dart:developer';

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
  int featuredPageNumber = 0;
  bool isLoading = false;
  bool hasMoreBooks = true;
  List<BookEntity> booksList = [];

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _horizontalScrollController.addListener(_horizontalScrollListener);
  }

  void _horizontalScrollListener() async {
    if (!hasMoreBooks || isLoading) return;

    if (_horizontalScrollController.position.pixels >=
        _horizontalScrollController.position.maxScrollExtent * 0.7) {
      setState(() {
        isLoading = true;
      });
      featuredPageNumber++;
      // Fetch more featured books
      await BlocProvider.of<FeaturedBooksCubit>(
        context,
      ).fetchFeaturedBooks(pageNumber: featuredPageNumber);
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
          log('Featured books received: ${state.books.length} books');
          if (state.books.isEmpty || state.books.length < 10) {
            // If we got fewer than 10 books, we've reached the end
            setState(() {
              if (state.books.isNotEmpty) {
                log('Adding ${state.books.length} books to list (last page)');
                booksList.addAll(state.books);
              }
              hasMoreBooks = false;
              isLoading = false;
            });
          } else {
            setState(() {
              log(
                'Adding ${state.books.length} books to list. Total: ${booksList.length + state.books.length}',
              );
              booksList.addAll(state.books);
              isLoading = false;
            });
          }
        } else if (state is FeaturedBooksFailure) {
          log('Featured books fetch failed: ${state.errMessage}');
          setState(() {
            isLoading = false;
            hasMoreBooks = false;
          });
        }
      },
      builder: (context, state) {
        if (state is FeaturedBooksSuccess ||
            state is FeaturedBooksLoading ||
            state is FeaturedBooksPaginationLoading) {
          final itemCount = booksList.isNotEmpty ? booksList.length : 10;
          return SizedBox(
            height: 205,
            child: ListView.builder(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right:
                        booksList.isNotEmpty
                            ? (booksList[index] != booksList.last ? 15 : 0)
                            : (index != 9 ? 15 : 0),
                  ),
                  child: HorizontalBooksListItem(
                    imageUrl:
                        booksList.isNotEmpty ? booksList[index].thumbnail! : "",
                    bookEntity: booksList.isNotEmpty ? booksList[index] : null,
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
