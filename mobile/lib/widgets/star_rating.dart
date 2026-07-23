import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Renders a 0–5 star rating, supporting half stars (e.g. a 4.2 rating shows
/// four full stars and one half). Works for both the business rating (a double)
/// and individual review ratings (ints).
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.size = 18,
    this.color = AppColors.star,
  });

  final double rating;
  final double size;
  final Color color;

  StarRating.fromInt(
    int rating, {
    Key? key,
    double size = 18,
    Color color = AppColors.star,
  }) : this(key: key, rating: rating.toDouble(), size: size, color: color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final position = index + 1;
        IconData icon;
        if (rating >= position) {
          icon = Icons.star_rounded;
        } else if (rating >= position - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}
