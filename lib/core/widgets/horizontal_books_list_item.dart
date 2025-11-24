import 'package:bookly/core/utils/app_router.dart';
import 'package:bookly/core/widgets/custom_network_image.dart';
import 'package:bookly/features/home/domain/entities/book_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HorizontalBooksListItem extends StatelessWidget {
  const HorizontalBooksListItem({
    super.key,
    this.bookEntity,
    required this.imageUrl,
  });
  final BookEntity? bookEntity;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigate to book details view
        if (bookEntity != null) {
          GoRouter.of(context).push(AppRouter.kBooksView, extra: bookEntity);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 150,
          child: Hero(
            // make random tag if bookEntity is null
            tag: bookEntity?.id ?? UniqueKey().toString(),
            child: CustomNetworkImage(imageUrl: imageUrl),
          ),
        ),
      ),
    );
  }
}
