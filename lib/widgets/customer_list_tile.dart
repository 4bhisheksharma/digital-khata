import 'dart:math';
import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../utils/nepali_strings.dart';
import '../theme/app_theme.dart';

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

  Color _getAvatarColor(BuildContext context) {
    final colors = [
      AppTheme.primaryColor,
      const Color(0xFF1E88E5), // Blue
      const Color(0xFF43A047), // Green
      const Color(0xFF8E24AA), // Purple
      const Color(0xFFE53935), // Red
      const Color(0xFF3949AB), // Indigo
      const Color(0xFF00897B), // Teal
    ];

    // Use customer ID to consistently get same color for each customer
    final colorIndex = customer.id.hashCode % colors.length;
    return colors[colorIndex.abs()];
  }

  int min(int a, int b) => a < b ? a : b;

  @override
  Widget build(BuildContext context) {
    final hasTransactions = customer.transactions.isNotEmpty;
    final lastTransaction = hasTransactions ? customer.transactions.last : null;
    final avatarColor = _getAvatarColor(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar with stacked badge for due amount
              Stack(
                children: [
                  Hero(
                    tag: 'customer_avatar_${customer.id}',
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: avatarColor,
                      child: Text(
                        _getInitials(customer.name),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  if (!showDueAmount && customer.totalDue > 0)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.warning_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Customer info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            customer.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '#${customer.uniqueId}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (showDueAmount) ...[
                      Text(
                        '${NepaliStrings.totalDue}: ${NepaliStrings.formatCurrency(customer.totalDue)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: customer.totalDue > 0
                                  ? AppTheme.errorColor
                                  : AppTheme.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                    if (hasTransactions) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Last: ${lastTransaction?.productName ?? ''} - ${lastTransaction?.nepaliDate ?? ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!showDueAmount && customer.totalDue > 0) ...[
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.errorColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    NepaliStrings.formatCurrency(customer.totalDue),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.w600,
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
