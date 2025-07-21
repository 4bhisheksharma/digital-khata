import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../models/customer.dart';
import '../utils/nepali_strings.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/add_transaction_form.dart';
import '../theme/app_theme.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${customer.name} • ${customer.uniqueId}'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Summary Card
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NepaliStrings.totalDue,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    NepaliStrings.formatCurrency(customer.totalDue),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: customer.totalDue > 0
                          ? AppTheme.errorColor
                          : AppTheme.successColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${customer.transactions.length} ${NepaliStrings.transactions}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          // Transaction List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: customer.transactions.length,
              itemBuilder: (context, index) {
                final transaction = customer.transactions[index];
                return TransactionTile(transaction: transaction);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddTransactionForm(customerId: customer.id),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(NepaliStrings.addItem),
      ),
    );
  }
}
