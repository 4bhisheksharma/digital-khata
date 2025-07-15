import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../utils/nepali_strings.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(title: Text(NepaliStrings.reports), elevation: 0),
      body: FutureBuilder(
        future: firestoreService.getBusinessSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final summary = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(
                  context: context,
                  icon: Icons.people,
                  title: NepaliStrings.totalCustomers,
                  value: summary?.totalCustomers.toString() ?? '0',
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  context: context,
                  icon: Icons.shopping_cart,
                  title: NepaliStrings.totalTransactions,
                  value: summary?.totalTransactions.toString() ?? '0',
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  context: context,
                  icon: Icons.account_balance_wallet,
                  title: NepaliStrings.totalDue,
                  value: NepaliStrings.formatCurrency(
                    summary?.totalDueAmount ?? 0,
                  ),
                  valueColor: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  context: context,
                  icon: Icons.calendar_today,
                  title: NepaliStrings.todaysTransactions,
                  value: summary?.todaysTransactions.toString() ?? '0',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: valueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
