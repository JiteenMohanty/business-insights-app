import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api_client.dart';
import 'reviews_state.dart';

/// Owns loading of the reviews list (`GET /reviews`).
class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit(this._api) : super(const ReviewsState());

  final ApiClient _api;

  Future<void> load() async {
    emit(state.copyWith(status: ReviewsStatus.loading));
    try {
      final reviews = await _api.getReviews();
      emit(state.copyWith(
        status: ReviewsStatus.success,
        reviews: reviews,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReviewsStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
