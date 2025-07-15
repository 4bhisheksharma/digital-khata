import 'dart:math';

import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../utils/nepali_strings.dart';

class CustomerListTile extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;
  final bool showDueAmount;

  const CustomerListTile({
    super.key,
    required this.customer,
    required this.onTap,
    this.showDueAmount = false,
  });

  String _getInitials(String name) {
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, min(2, name.length)).toUpperCase();
  }

  int min(int a, int b) => a < b ? a : b;

  @override
  Widget build(BuildContext context) {
    final hasTransactions = customer.transactions.isNotEmpty;
    final lastTransaction = hasTransactions ? customer.transactions.last : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              Hero(
                tag: 'customer_avatar_${customer.id}',
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    _getInitials(customer.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Customer info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (showDueAmount) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${NepaliStrings.totalDue}: ${NepaliStrings.formatCurrency(customer.totalDues)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: customer.totalDues > 0
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (!showDueAmount && hasTransactions) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Last: ${lastTransaction?.productName ?? ''} - ${NepaliStrings.formatCurrency(lastTransaction?.price ?? 0)}',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Due amount
              if (!showDueAmount && customer.totalDues > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    NepaliStrings.formatCurrency(customer.totalDues),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
