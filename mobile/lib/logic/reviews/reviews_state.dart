import 'package:equatable/equatable.dart';

import '../../data/models/review.dart';

enum ReviewsStatus { initial, loading, success, failure }

/// State for the reviews feature. An empty [reviews] list with a
/// [ReviewsStatus.success] status represents the "no reviews yet" case.
class ReviewsState extends Equatable {
  const ReviewsState({
    this.status = ReviewsStatus.initial,
    this.reviews = const [],
    this.error,
  });

  final ReviewsStatus status;
  final List<Review> reviews;
  final String? error;

  ReviewsState copyWith({
    ReviewsStatus? status,
    List<Review>? reviews,
    String? error,
  }) {
    return ReviewsState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, reviews, error];
}
