import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../services/firestore_service.dart';
import '../services/test_data_service.dart';
import '../widgets/customer_list_tile.dart';
import '../widgets/add_customer_form.dart';
import 'customer_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  void _showAddCustomerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddCustomerForm(),
      ),
    ).then((customer) {
      if (customer != null) {
        // Navigate to customer detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerDetailScreen(customer: customer),
          ),
        );
      }
    });
  }

  void _showDataViewer() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Firebase Data Viewer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: StreamBuilder<List<Customer>>(
                  stream: Provider.of<FirestoreService>(
                    context,
                  ).fetchCustomers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final customer = snapshot.data![index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Document ID: ${customer.id}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Name: ${customer.name}'),
                                Text('Total Dues: ₨ ${customer.totalDues}'),
                                Text(
                                  'Transactions: ${customer.transactions.length}',
                                ),
                                if (customer.transactions.isNotEmpty) ...[
                                  const Divider(),
                                  const Text('Transactions:'),
                                  ...customer.transactions.map(
                                    (tx) => Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(
                                        '- ${tx.productName}: ₨ ${tx.price} (Due: ₨ ${tx.dueAmount})',
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Digital खाता',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Initialize test data
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () async {
              try {
                await TestDataService.initializeTestData();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Test data initialized successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error initializing test data: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            tooltip: 'Add Test Data',
          ),
          // Debug menu
          IconButton(
            icon: const Icon(Icons.data_array),
            onPressed: _showDataViewer,
            tooltip: 'View Firebase Data',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by 4-digit ID or name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          // Customer List
          Expanded(
            child: StreamBuilder<List<Customer>>(
              stream: firestoreService.fetchCustomers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final customers = snapshot.data!;

                // Filter customers based on search query
                final filteredCustomers = customers.where((customer) {
                  final name = customer.name.toLowerCase();
                  final id = customer.id;
                  return name.contains(_searchQuery) ||
                      id.contains(_searchQuery);
                }).toList();

                if (filteredCustomers.isEmpty) {
                  if (_searchQuery.isEmpty) {
                    return const Center(
                      child: Text('No customers yet. Add your first customer!'),
                    );
                  } else {
                    return const Center(
                      child: Text('No matching customers found.'),
                    );
                  }
                }

                return ListView.builder(
                  itemCount: filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = filteredCustomers[index];
                    return CustomerListTile(
                      customer: customer,
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCustomerSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
