import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Renders a 0–5 star rating, supporting half stars (e.g. 4.2 shows four full
/// stars and one half). Used for both the business rating (a double) and
/// individual review ratings (ints).
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.size = 14,
  });

  final double rating;
  final double size;

  StarRating.fromInt(int rating, {Key? key, double size = 14})
      : this(key: key, rating: rating.toDouble(), size: size);

  @override
  Widget build(BuildContext context) {
    final filled = context.palette.star;
    final empty = context.colors.onSurfaceVariant.withValues(alpha: 0.35);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final position = index + 1;
        if (rating >= position) {
          return Icon(Icons.star_rounded, size: size, color: filled);
        }
        if (rating >= position - 0.5) {
          return Icon(Icons.star_half_rounded, size: size, color: filled);
        }
        return Icon(Icons.star_outline_rounded, size: size, color: empty);
      }),
    );
  }
}
