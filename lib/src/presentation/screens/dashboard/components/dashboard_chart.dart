import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  Widget _buildChartBar(double height, String label) {
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
            color: Colors.grey[600],
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
            color: Colors.grey[800],
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Dimens.p4),
        Container(
          height: 200,
          padding: const EdgeInsets.all(Dimens.p4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimens.p4),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
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
                      color: Colors.grey[800],
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
                    _buildChartBar(0.3, 'Mon'),
                    _buildChartBar(0.5, 'Tue'),
                    _buildChartBar(0.7, 'Wed'),
                    _buildChartBar(0.4, 'Thu'),
                    _buildChartBar(0.8, 'Fri'),
                    _buildChartBar(0.6, 'Sat'),
                    _buildChartBar(0.9, 'Sun'),
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
