import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/components/dashboard_chart.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/components/dashboard_header.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/components/expense_summary_cards.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/components/quick_actions.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/components/recent_transactions.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(Dimens.p4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            SizedBox(height: Dimens.p6),
            ExpenseSummaryCards(),
            SizedBox(height: Dimens.p6),
            QuickActions(),
            SizedBox(height: Dimens.p6),
            RecentTransactions(),
            SizedBox(height: Dimens.p6),
            DashboardChart(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
