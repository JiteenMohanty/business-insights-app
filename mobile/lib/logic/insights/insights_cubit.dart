import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api_client.dart';
import 'insights_state.dart';

/// Owns loading of the engagement insights (`GET /insights`).
class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit(this._api) : super(const InsightsState());

  final ApiClient _api;

  Future<void> load() async {
    emit(state.copyWith(status: InsightsStatus.loading));
    try {
      final insights = await _api.getInsights();
      emit(state.copyWith(
        status: InsightsStatus.success,
        insights: insights,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: InsightsStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
