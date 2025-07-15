import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../models/customer.dart';
import '../models/business_summary.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  // Get stream of all customers
  Stream<List<Customer>> fetchCustomers() {
    return _firestore.collection('customers').snapshots().map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) => Customer.fromMap(doc.data()))
            .where(
              (customer) => customer.id.isNotEmpty,
            ) // Filter out invalid data
            .toList();
      } catch (e) {
        print('Error fetching customers: $e');
        return <Customer>[];
      }
    });
  }

  // Get top due customers
  Future<List<Customer>> getTopDueCustomers() async {
    try {
      final snapshot = await _firestore.collection('customers').get();
      if (snapshot.docs.isEmpty) {
        return [];
      }

      final customers = snapshot.docs
          .map((doc) => Customer.fromMap(doc.data()))
          .where(
            (customer) => customer.id.isNotEmpty,
          ) // Filter out invalid data
          .toList();

      // Sort by total dues in descending order
      customers.sort((a, b) => b.totalDues.compareTo(a.totalDues));

      // Return only customers with dues > 0, limited to top 10
      return customers
          .where((customer) => customer.totalDues > 0)
          .take(10)
          .toList();
    } catch (e) {
      print('Error getting top due customers: $e');
      return [];
    }
  }

  // Get business summary
  Future<BusinessSummary> getBusinessSummary() async {
    try {
      final customersSnapshot = await _firestore.collection('customers').get();
      if (customersSnapshot.docs.isEmpty) {
        return BusinessSummary(
          totalCustomers: 0,
          totalTransactions: 0,
          totalDueAmount: 0,
          todaysTransactions: 0,
        );
      }

      final customers = customersSnapshot.docs
          .map((doc) => Customer.fromMap(doc.data()))
          .where(
            (customer) => customer.id.isNotEmpty,
          ) // Filter out invalid data
          .toList();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      int totalTransactions = 0;
      int todaysTransactions = 0;
      double totalDueAmount = 0;

      for (final customer in customers) {
        totalTransactions += customer.transactions.length;
        totalDueAmount += customer.totalDues;

        // Count today's transactions
        todaysTransactions += customer.transactions.where((transaction) {
          final txDate = transaction.timestamp;
          return txDate.isAfter(today);
        }).length;
      }

      return BusinessSummary(
        totalCustomers: customers.length,
        totalTransactions: totalTransactions,
        totalDueAmount: totalDueAmount,
        todaysTransactions: todaysTransactions,
      );
    } catch (e) {
      print('Error getting business summary: $e');
      return BusinessSummary(
        totalCustomers: 0,
        totalTransactions: 0,
        totalDueAmount: 0,
        todaysTransactions: 0,
      );
    }
  }

  // Get stream of customer's transactions
  Stream<List<Transaction>> fetchTransactions(String customerId) {
    return _firestore.collection('customers').doc(customerId).snapshots().map((
      doc,
    ) {
      try {
        return doc.exists ? Customer.fromMap(doc.data()).transactions : [];
      } catch (e) {
        print('Error fetching transactions: $e');
        return <Transaction>[];
      }
    });
  }

  // Add a new transaction
  Future<void> addTransaction(
    String customerId,
    Transaction transaction,
  ) async {
    try {
      final customerRef = _firestore.collection('customers').doc(customerId);

      return _firestore.runTransaction((txn) async {
        final customerDoc = await txn.get(customerRef);

        if (!customerDoc.exists) {
          throw Exception('Customer not found');
        }

        final customer = Customer.fromMap(customerDoc.data());
        final updatedTransactions = [...customer.transactions, transaction];

        txn.update(customerRef, {
          'transactions': updatedTransactions.map((tx) => tx.toMap()).toList(),
        });
      });
    } catch (e) {
      print('Error adding transaction: $e');
      rethrow;
    }
  }

  // Add a new customer
  Future<void> addCustomer(Customer customer) async {
    try {
      return await _firestore
          .collection('customers')
          .doc(customer.id)
          .set(customer.toMap());
    } catch (e) {
      print('Error adding customer: $e');
      rethrow;
    }
  }
}
