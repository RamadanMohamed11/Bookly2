import 'package:bookly/core/widgets/custom_network_image.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../../../core/widgets/horizontal_books_list_item.dart';
import '../../view_models/similar_books_cubit/similar_books_cubit.dart';
import 'book_app_bar.dart';
import 'price_and_free_preview_widget.dart';
import 'rate_widget.dart';

class BooksViewBody extends StatelessWidget {
  const BooksViewBody({super.key, required this.bookEntity});
  final BookEntity bookEntity;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
            child: BookAppBar(),
          ),
          SizedBox(height: 33.2),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              width: 162,
              child: AspectRatio(
                aspectRatio: 162 / 243,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag: bookEntity.id,
                    child: CustomNetworkImage(
                      imageUrl: bookEntity.thumbnail ?? '',
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 45),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Text(
              bookEntity.title,
              style: Styles.gTsectraFineRegular30,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8),
          bookEntity.author != null
              ? Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  bookEntity.author!,
                  style: Styles.montserratMedium18,
                ),
              )
              : SizedBox(),
          SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: RateWidget(
              rate: bookEntity.averageRating ?? 0,
              reviews: bookEntity.ratingsCount ?? 0,
            ),
          ),
          SizedBox(height: 52),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: PriceAndFreePreviewWidget(bookEntity: bookEntity),
          ),
          SizedBox(height: 51),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "You can also like",
                style: Styles.montserratSemiBold14,
              ),
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 205,
            child: BlocBuilder<SimilarBooksCubit, SimilarBooksState>(
              builder: (context, state) {
                if (state is SimilarBooksSuccess ||
                    state is SimilarBooksLoading) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount:
                        state is SimilarBooksSuccess
                            ? state.booksList.length
                            : 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right:
                              state is SimilarBooksSuccess
                                  ? (state.booksList[index] !=
                                          state.booksList.last
                                      ? 15
                                      : 0)
                                  : (index != 9 ? 15 : 0),
                        ),
                        child: HorizontalBooksListItem(
                          imageUrl:
                              state is SimilarBooksSuccess
                                  ? state
                                      .booksList[index]
                                      .volumeInfo
                                      .imageLinks
                                      .thumbnail
                                  : "",
                          bookEntity:
                              state is SimilarBooksSuccess
                                  ? state.booksList[index]
                                  : null,
                        ),
                      );
                    },
                  );
                } else if (state is SimilarBooksFailure) {
                  return CustomErrorWidget(errorMessage: state.errorMessage);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
