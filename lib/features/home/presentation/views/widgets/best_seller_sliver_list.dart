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
  List<BookEntity> booksList = [];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(listenerMethod);
  }

  void listenerMethod() async {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent * 0.7) {
      if (!isLoading) {
        isLoading = true;
        // fetch more books
        await BlocProvider.of<NewestBooksCubit>(
          context,
        ).fetchNewestBooks(pageNumber: pageNumber);
        pageNumber++;
        isLoading = false;
      }
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
          booksList.addAll(state.booksList);
        }
      },
      builder: (context, state) {
        if (state is NewestBooksSuccess ||
            state is NewestBooksLoading ||
            state is NewestBooksPaginationLoading) {
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                  left: 30,
                  right: 30,
                ),
                child: BestSellerWidget(
                  bookEntity:
                      (state is NewestBooksSuccess ||
                              state is NewestBooksPaginationLoading)
                          ? booksList[index]
                          : null,
                ).redacted(
                  context: context,
                  redact: state is NewestBooksLoading,
                  configuration: RedactedConfiguration(
                    animationDuration: Duration(milliseconds: 500),
                  ),
                ),
              );
            }, childCount: state is NewestBooksSuccess ? booksList.length : 10),
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
