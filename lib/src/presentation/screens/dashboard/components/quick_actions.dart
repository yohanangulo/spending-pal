import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            color: context.theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ).fadeInLeft(
          from: 20,
          delay: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 300),
        ),
        const SizedBox(height: Dimens.p4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickActionButton(
              icon: Icons.add,
              label: 'Add Expense',
              onTap: () {},
            ).zoomIn(
              delay: const Duration(milliseconds: 100),
            ),
            _QuickActionButton(
              icon: Icons.analytics,
              label: 'View Reports',
              onTap: () {},
            ).zoomIn(
              delay: const Duration(milliseconds: 500),
            ),
            _QuickActionButton(
              icon: Icons.category,
              label: 'Categories',
              onTap: () {},
            ).zoomIn(
              delay: const Duration(milliseconds: 900),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimens.p4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(Dimens.p4),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: context.theme.colorScheme.onSurface.withValues(alpha: 0.04),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),
            const SizedBox(height: Dimens.p2),
            Text(
              label,
              style: TextStyle(
                color: context.theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
