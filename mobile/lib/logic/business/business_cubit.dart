import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api_client.dart';
import 'business_state.dart';

/// Owns loading of the business profile (`GET /business`).
class BusinessCubit extends Cubit<BusinessState> {
  BusinessCubit(this._api) : super(const BusinessState());

  final ApiClient _api;

  Future<void> load() async {
    emit(state.copyWith(status: BusinessStatus.loading));
    try {
      final business = await _api.getBusiness();
      emit(state.copyWith(
        status: BusinessStatus.success,
        business: business,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BusinessStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
