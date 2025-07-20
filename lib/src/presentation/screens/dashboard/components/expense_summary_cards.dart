import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class ExpenseSummaryCards extends StatelessWidget {
  const ExpenseSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Summary',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ).fadeInLeft(
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 300),
        ),
        const SizedBox(height: Dimens.p4),
        Row(
          children: [
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 2000),
                curve: const ElasticOutCurve(0.8),
                child: const SummaryCard(
                  title: 'Expenses',
                  amount: r'$2,450',
                  icon: Icons.trending_down,
                  color: Color.fromARGB(255, 239, 44, 83),
                  percentage: '+12%',
                ),
                builder: (context, value, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-(1 - value) * 80 / 180 * math.pi),
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(0, 120 * (1 - value)),
                      child: Opacity(
                        opacity: value.clamp(0, 1),
                        child: child,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: Dimens.p4),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 2),
                duration: const Duration(milliseconds: 2500),
                curve: const ElasticOutCurve(0.8),
                child: const SummaryCard(
                  title: 'Income',
                  amount: r'$4,200',
                  icon: Icons.trending_up,
                  color: AppColors.primary,
                  percentage: '+8%',
                ),
                builder: (context, value, child) {
                  value = value - 1;
                  if (value < 0) {
                    return const SizedBox.shrink();
                  }

                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-(1 - value) * 80 / 180 * math.pi),
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(0, 160 * (1 - value)),
                      child: Opacity(
                        opacity: value.clamp(0, 1),
                        child: child,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimens.p4),
        const SummaryCard(
          title: 'Balance',
          amount: r'$1,750',
          icon: Icons.account_balance_wallet,
          color: AppColors.primary,
          percentage: '+5%',
          isFullWidth: true,
        ).bounceInUp(
          from: 100,
          curve: const ElasticOutCurve(0.8),
          delay: const Duration(milliseconds: 450),
          duration: const Duration(milliseconds: 1800),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.percentage,
    this.isFullWidth = false,
    super.key,
  });

  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final String percentage;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(Dimens.p4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.p4),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.p2,
                  vertical: Dimens.p1,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimens.p2),
                ),
                child: Text(
                  percentage,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.p3),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: Dimens.p1),
          Text(
            amount,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
