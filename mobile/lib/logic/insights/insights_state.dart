import 'package:equatable/equatable.dart';

import '../../data/models/insights.dart';

enum InsightsStatus { initial, loading, success, failure }

/// State for the insights dashboard feature.
class InsightsState extends Equatable {
  const InsightsState({
    this.status = InsightsStatus.initial,
    this.insights,
    this.error,
  });

  final InsightsStatus status;
  final Insights? insights;
  final String? error;

  InsightsState copyWith({
    InsightsStatus? status,
    Insights? insights,
    String? error,
  }) {
    return InsightsState(
      status: status ?? this.status,
      insights: insights ?? this.insights,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, insights, error];
}
