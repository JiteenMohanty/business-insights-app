import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/models/insights.dart';

/// Bar chart that visualizes all five insight metrics together (satisfies the
/// assignment's chart bonus). Each bar uses the same color as its metric card.
class InsightsChart extends StatelessWidget {
  const InsightsChart({super.key, required this.insights});

  final Insights insights;

  @override
  Widget build(BuildContext context) {
    final values = insights.orderedValues;
    final maxValue =
        values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b);
    // Headroom above the tallest bar so labels/tooltips aren't clipped.
    final maxY = maxValue == 0 ? 10.0 : maxValue * 1.2;

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.textPrimary,
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, _, rod, __) {
                return BarTooltipItem(
                  '${Insights.fullLabels[group.x]}\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: rod.toY.round().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
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
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= Insights.shortLabels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      Insights.shortLabels[index],
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
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
                FlLine(color: AppColors.border, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (var i = 0; i < values.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: values[i].toDouble(),
                    color: AppColors.metric[i % AppColors.metric.length],
                    width: 18,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
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
