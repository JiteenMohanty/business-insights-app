import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/formatters.dart';
import '../data/models/business.dart';
import '../logic/business/business_cubit.dart';
import '../logic/business/business_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';
import '../widgets/star_rating.dart';
import '../widgets/status_views.dart';

/// Business profile: name, category, rating summary, and contact details.
class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessCubit, BusinessState>(
      builder: (context, state) {
        switch (state.status) {
          case BusinessStatus.loading:
          case BusinessStatus.initial:
            return const LoadingView();
          case BusinessStatus.failure:
            return ErrorView(
              message: state.error ?? 'Could not load business details.',
              onRetry: () => context.read<BusinessCubit>().load(),
            );
          case BusinessStatus.success:
            return _BusinessContent(business: state.business!);
        }
      },
    );
  }
}

class _BusinessContent extends StatelessWidget {
  const _BusinessContent({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final initial =
        business.name.isNotEmpty ? business.name[0].toUpperCase() : '?';

    return RefreshIndicator(
      onRefresh: () => context.read<BusinessCubit>().load(),
      child: ListView(
        padding: AppSpacing.screen,
        children: [
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.palette.subtleSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.palette.border),
                  ),
                  child: Text(
                    initial,
                    style: context.texts.headlineSmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name,
                        style: context.texts.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(business.category, style: context.texts.labelSmall),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          StarRating(rating: business.rating, size: 14),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            business.rating.toStringAsFixed(1),
                            style: context.texts.titleSmall,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              '(${formatCount(business.totalReviews)} reviews)',
                              style: context.texts.labelSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader('Details'),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: business.address,
                ),
                const Divider(),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: business.phone,
                ),
                const Divider(),
                _InfoRow(
                  icon: Icons.category_outlined,
                  label: 'Category',
                  value: business.category,
                ),
                const Divider(),
                _InfoRow(
                  icon: Icons.star_outline_rounded,
                  label: 'Rating',
                  value: '${business.rating.toStringAsFixed(1)} / 5',
                ),
                const Divider(),
                _InfoRow(
                  icon: Icons.rate_review_outlined,
                  label: 'Total Reviews',
                  value: formatCount(business.totalReviews),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: context.colors.onSurfaceVariant),
          const SizedBox(width: AppSpacing.md),
          Text(label, style: context.texts.labelSmall),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: context.texts.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
