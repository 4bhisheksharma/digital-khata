import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../models/customer.dart';

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
            '₨ ${transaction.price.toStringAsFixed(2)} / ₨ ${transaction.dueAmount.toStringAsFixed(2)} due',
            style: TextStyle(
              color: transaction.dueAmount > 0 ? Colors.red : Colors.green,
            ),
          ),
          Text(
            NepaliDateFormat.yMMMEd().format(transaction.date),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
