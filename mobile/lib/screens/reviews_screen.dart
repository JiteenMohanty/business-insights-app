import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/reviews/reviews_cubit.dart';
import '../logic/reviews/reviews_state.dart';
import '../widgets/review_tile.dart';
import '../widgets/status_views.dart';

/// Reviews list with loading, error, and empty states.
class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        switch (state.status) {
          case ReviewsStatus.loading:
          case ReviewsStatus.initial:
            return const LoadingView();
          case ReviewsStatus.failure:
            return ErrorView(
              message: state.error ?? 'Could not load reviews.',
              onRetry: () => context.read<ReviewsCubit>().load(),
            );
          case ReviewsStatus.success:
            if (state.reviews.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<ReviewsCubit>().load(),
                child: const _EmptyReviews(),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<ReviewsCubit>().load(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.reviews.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    ReviewTile(review: state.reviews[index]),
              ),
            );
        }
      },
    );
  }
}

class _EmptyReviews extends StatelessWidget {
  const _EmptyReviews();

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Ensures pull-to-refresh works even though the content is centered.
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 160),
        EmptyView(
          message: 'No reviews yet.',
          icon: Icons.reviews_outlined,
        ),
      ],
    );
  }
}
