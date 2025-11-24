import 'package:bookly/features/home/domain/entities/book_entity.dart';

import '../../../../../core/widgets/custom_circular_progress_indicator.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../manager/newest_books_cubit/newest_books_cubit.dart';
import 'best_seller_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted/redacted.dart';

class BestSellerSliverList extends StatefulWidget {
  const BestSellerSliverList({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<BestSellerSliverList> createState() => _BestSellerSliverListState();
}

class _BestSellerSliverListState extends State<BestSellerSliverList> {
  int pageNumber = 1;
  bool isLoading = false;
  bool hasMoreBooks = true;
  List<BookEntity> booksList = [];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(listenerMethod);
  }

  void listenerMethod() async {
    if (!hasMoreBooks || isLoading) return;

    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent * 0.7) {
      setState(() {
        isLoading = true;
      });
      pageNumber++;
      // fetch more books
      await BlocProvider.of<NewestBooksCubit>(
        context,
      ).fetchNewestBooks(pageNumber: pageNumber);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(listenerMethod);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewestBooksCubit, NewestBooksState>(
      listener: (context, state) {
        if (state is NewestBooksSuccess) {
          if (state.booksList.isEmpty || state.booksList.length < 10) {
            // If we got fewer than 10 books, we've reached the end
            setState(() {
              if (state.booksList.isNotEmpty) {
                booksList.addAll(state.booksList);
              }
              hasMoreBooks = false;
              isLoading = false;
            });
          } else {
            setState(() {
              booksList.addAll(state.booksList);
              isLoading = false;
            });
          }
        } else if (state is NewestBooksFailure) {
          setState(() {
            isLoading = false;
            hasMoreBooks = false;
          });
        }
      },
      builder: (context, state) {
        if (state is NewestBooksSuccess ||
            state is NewestBooksLoading ||
            state is NewestBooksPaginationLoading) {
          final itemCount = booksList.isNotEmpty ? booksList.length : 10;
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                  left: 30,
                  right: 30,
                ),
                child: BestSellerWidget(
                  bookEntity: booksList.isNotEmpty ? booksList[index] : null,
                ).redacted(
                  context: context,
                  redact: state is NewestBooksLoading,
                  configuration: RedactedConfiguration(
                    animationDuration: Duration(milliseconds: 500),
                  ),
                ),
              );
            }, childCount: itemCount),
          );
        } else if (state is NewestBooksFailure) {
          return SliverToBoxAdapter(
            child: Center(
              child: CustomErrorWidget(errorMessage: (state.errorMessage)),
            ),
          );
        } else {
          return const SliverToBoxAdapter(
            child: Center(child: CustomCircularProgressIndicator()),
          );
        }
      },
    );
  }
}
