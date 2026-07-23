import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme.dart';
import '../data/models/insights.dart';
import '../logic/insights/insights_cubit.dart';
import '../logic/insights/insights_state.dart';
import '../widgets/app_card.dart';
import '../widgets/insights_chart.dart';
import '../widgets/metric_card.dart';
import '../widgets/status_views.dart';

/// Insights dashboard: five metric cards + a bar chart of all metrics together.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Icons for each metric, in the same order as Insights.orderedValues.
  static const _icons = [
    Icons.visibility_outlined,
    Icons.search_rounded,
    Icons.ads_click_rounded,
    Icons.call_outlined,
    Icons.directions_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsightsCubit, InsightsState>(
      builder: (context, state) {
        switch (state.status) {
          case InsightsStatus.loading:
          case InsightsStatus.initial:
            return const LoadingView();
          case InsightsStatus.failure:
            return ErrorView(
              message: state.error ?? 'Could not load insights.',
              onRetry: () => context.read<InsightsCubit>().load(),
            );
          case InsightsStatus.success:
            return _InsightsContent(insights: state.insights!, icons: _icons);
        }
      },
    );
  }
}

class _InsightsContent extends StatelessWidget {
  const _InsightsContent({required this.insights, required this.icons});

  final Insights insights;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    final values = insights.orderedValues;

    return RefreshIndicator(
      onRefresh: () => context.read<InsightsCubit>().load(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle('Engagement Insights'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              for (var i = 0; i < values.length; i++)
                MetricCard(
                  label: Insights.fullLabels[i],
                  value: values[i],
                  icon: icons[i],
                  color: AppColors.metric[i % AppColors.metric.length],
                ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Metrics Overview'),
          const SizedBox(height: 12),
          AppCard(
            child: InsightsChart(insights: insights),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}
