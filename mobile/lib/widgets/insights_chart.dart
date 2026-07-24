import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/models/insights.dart';
import '../theme/app_theme.dart';

/// Bar chart visualizing all five insight metrics together. Each bar uses the
/// same muted accent as its metric card, and all colors resolve from the active
/// theme so the chart reads correctly in both light and dark mode.
class InsightsChart extends StatelessWidget {
  const InsightsChart({super.key, required this.insights});

  final Insights insights;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colors = context.colors;
    final labelStyle = context.texts.labelSmall;

    final values = insights.orderedValues;
    final maxValue =
        values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b);
    // Headroom above the tallest bar so tooltips aren't clipped.
    final maxY = maxValue == 0 ? 10.0 : maxValue * 1.2;

    return SizedBox(
      height: 190,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => colors.inverseSurface,
              tooltipRoundedRadius: 6,
              getTooltipItem: (group, _, rod, __) {
                return BarTooltipItem(
                  '${Insights.fullLabels[group.x]}\n',
                  TextStyle(
                    color: colors.onInverseSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                  children: [
                    TextSpan(
                      text: rod.toY.round().toString(),
                      style: TextStyle(
                        color: colors.onInverseSurface,
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= Insights.shortLabels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      Insights.shortLabels[index],
                      style: labelStyle,
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: palette.border, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (var i = 0; i < values.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: values[i].toDouble(),
                    color: palette.metric[i % palette.metric.length],
                    width: 16,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
