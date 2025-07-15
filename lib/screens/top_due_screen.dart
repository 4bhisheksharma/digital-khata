import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../services/firestore_service.dart';
import '../utils/nepali_strings.dart';
import '../widgets/customer_list_tile.dart';
import 'customer_detail_screen.dart';

class TopDueScreen extends StatelessWidget {
  const TopDueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(NepaliStrings.topDue), elevation: 0),
      body: Consumer<FirestoreService>(
        builder: (context, firestoreService, _) {
          return FutureBuilder<List<Customer>>(
            future: firestoreService.getTopDueCustomers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final customers = snapshot.data ?? [];
              if (customers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        NepaliStrings.noDueCustomers,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: customers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return CustomerListTile(
                    customer: customer,
                    showDueAmount: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CustomerDetailScreen(customer: customer),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
