import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/formatters.dart';
import '../core/theme.dart';
import '../data/models/business.dart';
import '../logic/business/business_cubit.dart';
import '../logic/business/business_state.dart';
import '../widgets/app_card.dart';
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
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  business.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    business.category,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StarRating(rating: business.rating, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      business.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '  ·  ${formatCount(business.totalReviews)} reviews',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: business.address,
                ),
                const Divider(height: 1, color: AppColors.border),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: business.phone,
                ),
                const Divider(height: 1, color: AppColors.border),
                _InfoRow(
                  icon: Icons.star_outline_rounded,
                  label: 'Rating',
                  value: '${business.rating.toStringAsFixed(1)} / 5',
                ),
                const Divider(height: 1, color: AppColors.border),
                _InfoRow(
                  icon: Icons.reviews_outlined,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
