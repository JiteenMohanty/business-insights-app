import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';

/// A single insight metric: a quiet outlined icon, the value, and its label.
///
/// Sizing note: the grid gives each card a fixed height (see
/// [MetricCard.gridExtent]) rather than deriving one from `childAspectRatio`,
/// and both text runs are line-capped. That combination is what keeps this card
/// from overflowing regardless of device width.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final int value;
  final IconData icon;

  /// Subtle per-metric tint, used only for the icon so it reads as an accent
  /// rather than a focal point.
  final Color accent;

  /// Fixed row height used by the dashboard grid. Sized to fit the icon, a
  /// single-line value, and a two-line label with headroom.
  static const double gridExtent = 108;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 18, color: accent),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formatCount(value),
                style: context.texts.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: context.texts.labelSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
