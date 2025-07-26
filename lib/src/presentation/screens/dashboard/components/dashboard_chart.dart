import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

//  TODO: Change this chart
class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  Widget _buildChartBar(BuildContext context, double height, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 100 * height,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(Dimens.p1),
          ),
        ),
        const SizedBox(height: Dimens.p2),
        Text(
          label,
          style: TextStyle(
            color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Expenses',
          style: TextStyle(
            color: context.theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Dimens.p4),
        Container(
          height: 200,
          padding: const EdgeInsets.all(Dimens.p4),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(Dimens.p4),
            border: Border.all(
              color: context.theme.dividerColor,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Marzo 2024',
                    style: TextStyle(
                      color: context.theme.colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.bar_chart,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: Dimens.p6),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildChartBar(context, 0.3, 'Mon'),
                    _buildChartBar(context, 0.5, 'Tue'),
                    _buildChartBar(context, 0.7, 'Wed'),
                    _buildChartBar(context, 0.4, 'Thu'),
                    _buildChartBar(context, 0.8, 'Fri'),
                    _buildChartBar(context, 0.6, 'Sat'),
                    _buildChartBar(context, 0.9, 'Sun'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
