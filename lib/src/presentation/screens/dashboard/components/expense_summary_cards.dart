import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/common/widgets/scramble_currency_text.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/bloc/dashboard_bloc.dart';

class ExpenseSummaryCards extends StatelessWidget {
  const ExpenseSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          previous.totalExpense != current.totalExpense ||
          previous.totalIncome != current.totalIncome ||
          previous.isLoading != current.isLoading ||
          previous.totalsReady != current.totalsReady,
      builder: (context, state) {
        final onSurface = context.theme.colorScheme.onSurface;
        final amountStyle = TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Summary',
              style: TextStyle(
                color: context.theme.colorScheme.onSurface,
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
                    child: SummaryCard(
                      title: 'Expenses',
                      amount: ScrambleCurrencyText(
                        targetAmount: state.totalExpense,
                        isReady: state.totalsReady,
                        style: amountStyle,
                      ),
                      icon: Icons.trending_down,
                      color: const Color.fromARGB(255, 239, 44, 83),
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
                    child: SummaryCard(
                      title: 'Income',
                      amount: ScrambleCurrencyText(
                        targetAmount: state.totalIncome,
                        isReady: state.totalsReady,
                        style: amountStyle,
                      ),
                      icon: Icons.trending_up,
                      color: AppColors.primary,
                    ),
                    builder: (context, value, child) {
                      final v = value - 1;
                      if (v < 0) {
                        return const SizedBox.shrink();
                      }

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(-(1 - v) * 80 / 180 * math.pi),
                        alignment: Alignment.center,
                        child: Transform.translate(
                          offset: Offset(0, 160 * (1 - v)),
                          child: Opacity(
                            opacity: v.clamp(0, 1),
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
            SummaryCard(
              title: 'Balance',
              amount: ScrambleCurrencyText(
                targetAmount: state.balance,
                isReady: state.totalsReady,
                style: amountStyle,
              ),
              icon: Icons.account_balance_wallet,
              color: AppColors.primary,
              isFullWidth: true,
            ).bounceInUp(
              from: 100,
              curve: const ElasticOutCurve(0.8),
              delay: const Duration(milliseconds: 450),
              duration: const Duration(milliseconds: 1800),
            ),
          ],
        );
      },
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.isFullWidth = false,
    super.key,
  });

  final String title;
  final Widget amount;
  final IconData icon;
  final Color color;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final surface = context.theme.colorScheme.surface;
    final onSurface = context.theme.colorScheme.onSurface;
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(Dimens.p4),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(Dimens.p4),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: onSurface.withValues(alpha: 0.04),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: Dimens.p3),
          Text(
            title,
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: Dimens.p1),
          amount,
        ],
      ),
    );
  }
}
