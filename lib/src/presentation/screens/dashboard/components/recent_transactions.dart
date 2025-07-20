import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ).fadeInLeft(
              from: 20,
              delay: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 300),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View all',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimens.p4),
        DecoratedBox(
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
              const _TransactionItem(
                title: 'Coffee',
                category: 'Food',
                amount: r'-$4.50',
                date: 'Today',
                icon: Icons.coffee,
                color: Color.fromARGB(255, 255, 30, 0),
              ),
              const _Divider(),
              const _TransactionItem(
                title: 'Gasoline',
                category: 'Transport',
                amount: r'-$45.00',
                date: 'Yesterday',
                icon: Icons.local_gas_station,
                color: Color.fromARGB(255, 5, 181, 205),
              ),
              const _Divider(),
              _TransactionItem(
                title: 'Salary',
                category: 'Income',
                amount: r'$2,100.00',
                date: '15 Mar',
                icon: Icons.account_balance,
                color: AppColors.primary.withValues(alpha: 0.9),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.withValues(alpha: 0.2),
      height: 1,
      indent: Dimens.p12,
      endIndent: Dimens.p4,
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
  });

  final String title;
  final String category;
  final String amount;
  final String date;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.p4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Dimens.p3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimens.p3),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: Dimens.p4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: amount.startsWith('+') ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
