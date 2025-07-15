import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../models/customer.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/add_transaction_form.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${customer.name} • ${customer.id}')),
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
                    'Total Due',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₨ ${customer.totalDues.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: customer.totalDues > 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${customer.transactions.length} Transactions',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          // Transaction List
          Expanded(
            child: ListView.builder(
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
          _showAddTransactionSheet(context);
        },
        label: const Text('Add Item'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddTransactionForm(customerId: customer.id),
      ),
    );
  }
}
