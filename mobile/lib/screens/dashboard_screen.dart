import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/insights.dart';
import '../logic/insights/insights_cubit.dart';
import '../logic/insights/insights_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/insights_chart.dart';
import '../widgets/metric_card.dart';
import '../widgets/section_header.dart';
import '../widgets/status_views.dart';

/// Insights dashboard: five metric cards + a bar chart of all metrics together.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Outlined icons, in the same order as Insights.orderedValues.
  static const _icons = [
    Icons.visibility_outlined,
    Icons.search_outlined,
    Icons.ads_click_outlined,
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
    final metricColors = context.palette.metric;

    return RefreshIndicator(
      onRefresh: () => context.read<InsightsCubit>().load(),
      child: ListView(
        padding: AppSpacing.screen,
        children: [
          const SectionHeader('Engagement Insights'),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: values.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              // A fixed row height (rather than childAspectRatio) keeps the
              // card height independent of device width, so the content can't
              // be squeezed into too little vertical space.
              mainAxisExtent: MetricCard.gridExtent,
            ),
            itemBuilder: (context, i) => MetricCard(
              label: Insights.fullLabels[i],
              value: values[i],
              icon: icons[i],
              accent: metricColors[i % metricColors.length],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader('Metrics Overview'),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: InsightsChart(insights: insights),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
