import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/transaction/domain.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    required this.transaction,
    required this.onDelete,
    this.onTap,
    super.key,
  });

  final Transaction transaction;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? Colors.green : Colors.red;
    final amountPrefix = isIncome ? '+' : '-';
    final formattedAmount = NumberFormat.currency(symbol: r'$').format(transaction.amount);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.p2),
      child: Slidable(
        key: ValueKey(transaction.id),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(Dimens.p3),
              onPressed: (_) => onDelete(),
              backgroundColor: AppColors.destructive,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Card(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.symmetric(
            horizontal: Dimens.p4,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(Dimens.p4),
            leading: Container(
              padding: const EdgeInsets.all(Dimens.p3),
              decoration: BoxDecoration(
                color: transaction.category.color.toColor().withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimens.p3),
              ),
              child: Icon(
                transaction.category.icon.toIconData(),
                color: transaction.category.color.toColor(),
                size: 24,
              ),
            ),
            title: Text(
              transaction.description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              transaction.category.name,
              style: TextStyle(
                color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$amountPrefix$formattedAmount',
                  style: TextStyle(
                    color: amountColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: Dimens.p1),
                Text(
                  _formatDate(transaction.date),
                  style: TextStyle(
                    color: context.theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDay = DateTime(date.year, date.month, date.day);

    if (transactionDay == today) {
      return DateFormat('HH:mm').format(date);
    } else if (transactionDay == yesterday) {
      return 'Yesterday';
    } else if (date.year == now.year) {
      return DateFormat('MMM dd').format(date);
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }
}
