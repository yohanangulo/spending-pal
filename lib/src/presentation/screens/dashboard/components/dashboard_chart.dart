import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/bloc/dashboard_bloc.dart';

class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  static const _barWidth = 12.0;
  static const _barsSpace = 4.0;
  static const _barRadius = BorderRadius.vertical(top: Radius.circular(4));
  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static bool _allZero(List<DailyTotal> totals) {
    return totals.every((d) => d.income == 0 && d.expense == 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          previous.weeklyTotals != current.weeklyTotals || previous.weeklyTotalsReady != current.weeklyTotalsReady,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Overview',
              style: TextStyle(
                color: context.theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Dimens.p4),
            Container(
              padding: const EdgeInsets.all(Dimens.p4),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(Dimens.p4),
                border: Border.all(color: context.theme.dividerColor),
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
                  _Legend(onSurface: context.theme.colorScheme.onSurface),
                  const SizedBox(height: Dimens.p4),
                  SizedBox(
                    height: 180,
                    child: !state.weeklyTotalsReady
                        ? const _ShimmerPlaceholder()
                        : state.weeklyTotals.isEmpty || _allZero(state.weeklyTotals)
                        ? _EmptyState(
                            onSurface: context.theme.colorScheme.onSurface,
                          )
                        : _WeeklyBarChart(
                            weeklyTotals: state.weeklyTotals,
                            onSurface: context.theme.colorScheme.onSurface,
                            tooltipBackground: context.theme.colorScheme.surfaceContainerHighest,
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).fadeInUp();
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.onSurface});

  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LegendDot(color: AppColors.primary, label: 'Income', onSurface: onSurface),
        const SizedBox(width: Dimens.p4),
        _LegendDot(color: AppColors.destructive, label: 'Expense', onSurface: onSurface),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    required this.onSurface,
  });

  final Color color;
  final String label;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: Dimens.p1),
        Text(
          label,
          style: TextStyle(
            color: onSurface.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  const _WeeklyBarChart({
    required this.weeklyTotals,
    required this.onSurface,
    required this.tooltipBackground,
  });

  final List<DailyTotal> weeklyTotals;
  final Color onSurface;
  final Color tooltipBackground;

  double get _maxY {
    final maxVal = weeklyTotals.fold<double>(
      0,
      (prev, d) => math.max(prev, math.max(d.income, d.expense)),
    );
    if (maxVal == 0) return 10;
    return maxVal * 1.2;
  }

  double get _interval {
    final raw = _maxY / 4;
    if (raw <= 0) return 1;
    final magnitude = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
    final normalized = raw / magnitude;
    if (normalized <= 1) return magnitude;
    if (normalized <= 2) return 2 * magnitude;
    if (normalized <= 5) return 5 * magnitude;
    return 10 * magnitude;
  }

  static String _formatValue(double value) {
    if (value == 0) return '0';
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: _maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            tooltipBorderRadius: BorderRadius.circular(8),
            getTooltipColor: (_) => tooltipBackground,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (groupIndex < 0 || groupIndex >= weeklyTotals.length) return null;
              final daily = weeklyTotals[groupIndex];
              final dayName = DashboardChart._dayLabels[daily.date.weekday - 1];

              return BarTooltipItem(
                '$dayName\n',
                TextStyle(
                  color: onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                children: [
                  TextSpan(
                    text: 'Income: \$${daily.income.toStringAsFixed(2)}\n',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: 'Expense: \$${daily.expense.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.destructive,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: _interval,
              getTitlesWidget: (value, meta) {
                if (value == meta.max) return const SizedBox.shrink();
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    _formatValue(value),
                    style: TextStyle(
                      color: onSurface.withValues(alpha: 0.4),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= DashboardChart._dayLabels.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    DashboardChart._dayLabels[index],
                    style: TextStyle(
                      color: onSurface.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: _interval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: onSurface.withValues(alpha: 0.08),
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),
        barGroups: List.generate(weeklyTotals.length, (i) {
          final daily = weeklyTotals[i];
          return BarChartGroupData(
            x: i,
            barsSpace: DashboardChart._barsSpace,
            barRods: [
              BarChartRodData(
                toY: daily.income,
                color: AppColors.primary,
                width: DashboardChart._barWidth,
                borderRadius: DashboardChart._barRadius,
              ),
              BarChartRodData(
                toY: daily.expense,
                color: AppColors.destructive,
                width: DashboardChart._barWidth,
                borderRadius: DashboardChart._barRadius,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatefulWidget {
  const _ShimmerPlaceholder();

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = context.theme.colorScheme.onSurface.withValues(alpha: 0.06);
    final highlightColor = context.theme.colorScheme.onSurface.withValues(alpha: 0.12);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final shimmerValue = _controller.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (i) {
            final phase = (shimmerValue + i * 0.1) % 1.0;
            final opacity = 0.3 + 0.7 * (0.5 + 0.5 * math.sin(phase * math.pi * 2));
            final height = 40.0 + (i % 3) * 25.0;
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 10,
                  height: height * opacity,
                  decoration: BoxDecoration(
                    color: Color.lerp(baseColor, highlightColor, opacity),
                    borderRadius: DashboardChart._barRadius,
                  ),
                ),
                const SizedBox(width: 3),
                Container(
                  width: 10,
                  height: (height * 0.7) * opacity,
                  decoration: BoxDecoration(
                    color: Color.lerp(baseColor, highlightColor, opacity * 0.8),
                    borderRadius: DashboardChart._barRadius,
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onSurface});

  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 36,
            color: onSurface.withValues(alpha: 0.15),
          ),
          const SizedBox(height: Dimens.p2),
          Text(
            'No transactions this week',
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.4),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
