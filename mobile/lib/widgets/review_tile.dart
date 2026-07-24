import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../data/models/review.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';
import 'star_rating.dart';

/// A single review: reviewer initial, name, date, star rating, and comment.
class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final initial = review.name.isNotEmpty ? review.name[0].toUpperCase() : '?';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.palette.subtleSurface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: context.palette.border),
                ),
                child: Text(
                  initial,
                  style: context.texts.titleSmall,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.name, style: context.texts.titleSmall),
                    const SizedBox(height: 1),
                    Text(
                      formatReviewDate(review.date),
                      style: context.texts.labelSmall,
                    ),
                  ],
                ),
              ),
              StarRating.fromInt(review.rating, size: 13),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(review.comment, style: context.texts.bodyMedium),
        ],
      ),
    );
  }
}
