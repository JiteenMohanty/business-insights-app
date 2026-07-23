/// A single customer review returned by `GET /reviews`.
class Review {
  const Review({
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
  });

  final String name;
  final int rating;
  final String comment;

  /// Kept as the raw string from the API (e.g. `2026-03-20`); formatted for
  /// display via `formatReviewDate`.
  final String date;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['name'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      date: json['date']?.toString() ?? '',
    );
  }
}
