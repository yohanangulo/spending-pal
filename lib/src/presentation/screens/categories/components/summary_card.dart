import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/categories/bloc/categories_bloc.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(Dimens.p4),
        padding: const EdgeInsets.all(Dimens.p4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.category,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: Dimens.p4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Categories',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  const _CategoryCount(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCount extends StatelessWidget {
  const _CategoryCount();

  @override
  Widget build(BuildContext context) {
    final categories = context.select((CategoriesBloc bloc) => bloc.state.categories);
    return Text(
      '${categories.length}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
