import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../utils/nepali_strings.dart';
import '../theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        transaction.productName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${NepaliStrings.formatCurrency(transaction.price)} / ${NepaliStrings.formatCurrency(transaction.dueAmount)} ${NepaliStrings.dueAmount}',
            style: TextStyle(
              color: transaction.dueAmount > 0
                  ? AppTheme.errorColor
                  : AppTheme.successColor,
            ),
          ),
          Text(
            transaction.nepaliDate,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
