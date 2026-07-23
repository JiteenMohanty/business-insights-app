import 'package:equatable/equatable.dart';

import '../../data/models/business.dart';

enum BusinessStatus { initial, loading, success, failure }

/// State for the business profile feature. Exposes explicit
/// loading/success/error phases via [status].
class BusinessState extends Equatable {
  const BusinessState({
    this.status = BusinessStatus.initial,
    this.business,
    this.error,
  });

  final BusinessStatus status;
  final Business? business;
  final String? error;

  BusinessState copyWith({
    BusinessStatus? status,
    Business? business,
    String? error,
  }) {
    return BusinessState(
      status: status ?? this.status,
      business: business ?? this.business,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, business, error];
}
