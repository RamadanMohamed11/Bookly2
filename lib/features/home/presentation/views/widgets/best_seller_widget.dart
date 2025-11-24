import 'package:bookly/features/home/domain/entities/book_entity.dart';

import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:redacted/redacted.dart';

class BestSellerWidget extends StatelessWidget {
  const BestSellerWidget({super.key, this.bookEntity});
  final BookEntity? bookEntity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).push(AppRouter.kBooksView, extra: bookEntity);
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 110,
              width: 80,
              // child: Image.network(
              //   bookModel.volumeInfo.imageLinks.thumbnail,
              //   fit: BoxFit.fitHeight,
              // ),
              child: Hero(
                tag: bookEntity?.id ?? UniqueKey().toString(),
                child: CachedNetworkImage(
                  imageUrl: bookEntity?.thumbnail ?? '',
                  fit: BoxFit.fitHeight,
                  errorWidget:
                      (context, url, error) => Container(
                        color: Colors.grey,
                        width: 80,
                        height: 110,
                      ).redacted(
                        context: context,
                        redact: true,
                        configuration: RedactedConfiguration(
                          animationDuration: Duration(milliseconds: 450),
                        ),
                      ),
                ),
              ),
            ),
          ),
          SizedBox(width: 30),

          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookEntity?.title ?? '',
                  style: Styles.gTsectraFineRegular20,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 5),
                bookEntity?.author != null
                    ? Text(
                      bookEntity?.author! ?? '',
                      style: Styles.montserratMedium14,
                    )
                    : SizedBox(),
                SizedBox(width: 5),
                Row(
                  children: [
                    Text("Free", style: Styles.montserratBold20),
                    Spacer(),
                    Icon(Icons.star, color: Color(0xffFFDD4F)),
                    SizedBox(width: 4.2),
                    Text(
                      bookEntity?.averageRating?.toString() ?? "0",
                      style: Styles.montserratMedium16,
                    ),
                    SizedBox(width: 7),

                    Text(
                      "(${bookEntity?.ratingsCount?.toString() ?? "0"})",
                      style: Styles.montserratRegular14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
