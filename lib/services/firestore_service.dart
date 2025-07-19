import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../models/customer.dart';
import '../models/business_summary.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate a unique 4-digit customer ID
  Future<String> generateUniqueCustomerId() async {
    final random = DateTime.now().millisecondsSinceEpoch;
    final id = (1000 + (random % 9000)).toString();

    try {
      final doc = await _firestore
          .collection('customers')
          .where('uniqueId', isEqualTo: id)
          .get();

      if (doc.docs.isEmpty) {
        return id;
      } else {
        // If collision, generate a new random 6-digit ID
        final newId = (100000 + (random % 900000)).toString();
        return newId;
      }
    } catch (e) {
      print('Error generating unique customer ID: $e');
      // Fallback to timestamp string
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  // Add new customer
  Future<Customer> addCustomer(
    String name,
    String? phone,
    String? address,
  ) async {
    try {
      final uniqueId = await generateUniqueCustomerId();
      final now = NepaliDateTime.now();
      final nepaliDate = now.toString();

      final docRef = await _firestore.collection('customers').add({
        'name': name,
        'phone': phone,
        'address': address,
        'uniqueId': uniqueId,
        'totalDue': 0.0,
        'createdAt': Timestamp.fromDate(now.toDateTime()),
        'nepaliCreatedDate': nepaliDate,
        'transactions': [],
      });

      final createdDoc = await docRef.get();
      print('Customer added with ID: ${docRef.id}, uniqueId: $uniqueId');
      return Customer.fromSnapshot(createdDoc);
    } catch (e, stacktrace) {
      print('Error adding customer: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  // Get stream of all customers
  Stream<List<Customer>> fetchCustomers() {
    try {
      return _firestore
          .collection('customers')
          .orderBy('name')
          .snapshots()
          .handleError((error) {
            print('Error in customers stream: $error');
            return [];
          })
          .map((snapshot) {
            try {
              return snapshot.docs
                  .map((doc) {
                    try {
                      return Customer.fromSnapshot(doc);
                    } catch (e) {
                      print('Error parsing customer doc ${doc.id}: $e');
                      return null;
                    }
                  })
                  .where((customer) => customer != null)
                  .cast<Customer>()
                  .toList();
            } catch (e) {
              print('Error mapping customer documents: $e');
              return <Customer>[];
            }
          });
    } catch (e) {
      print('Error setting up customers stream: $e');
      return Stream.value(<Customer>[]);
    }
  }

  // Get customer by unique ID
  Future<Customer?> getCustomerByUniqueId(String uniqueId) async {
    try {
      final snapshot = await _firestore
          .collection('customers')
          .where('uniqueId', isEqualTo: uniqueId)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final doc = snapshot.docs.first;
      return Customer.fromSnapshot(doc);
    } catch (e) {
      print('Error getting customer by unique ID: $e');
      return null;
    }
  }

  // Add transaction for customer
  Future<void> addTransaction(
    String customerId,
    String productName,
    double price,
    double dueAmount,
  ) async {
    try {
      final customerRef = _firestore.collection('customers').doc(customerId);
      final now = NepaliDateTime.now();
      final nepaliDate = now.toString();
      final transactionId = DateTime.now().millisecondsSinceEpoch.toString();

      // First get the current customer data
      final customerDoc = await customerRef.get();
      if (!customerDoc.exists) {
        throw Exception('Customer not found');
      }

      final currentDue = (customerDoc.data()?['totalDue'] ?? 0.0) as double;
      final newTransaction = {
        'id': transactionId,
        'productName': productName,
        'price': price,
        'dueAmount': dueAmount,
        'date': Timestamp.fromDate(now.toDateTime()),
        'nepaliDate': nepaliDate,
      };

      final transactions = List<Map<String, dynamic>>.from(
        customerDoc.data()?['transactions'] ?? [],
      );
      transactions.add(newTransaction);

      // Update the customer document
      await customerRef.update({
        'totalDue': currentDue + dueAmount,
        'transactions': transactions,
      });
    } catch (e) {
      print('Error adding transaction: $e');
      rethrow;
    }
  }

  // Get business summary
  Future<BusinessSummary> getBusinessSummary() async {
    try {
      final now = NepaliDateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final customersSnapshot = await _firestore.collection('customers').get();

      double totalDueAmount = 0.0;
      int totalTransactions = 0;
      int todaysTransactions = 0;

      for (var doc in customersSnapshot.docs) {
        final data = doc.data();
        totalDueAmount += (data['totalDue'] ?? 0.0);
        final transactions = (data['transactions'] as List?) ?? [];
        totalTransactions += transactions.length;

        todaysTransactions += transactions.where((transaction) {
          final txDate = transaction['date'] as Timestamp;
          return txDate.toDate().isAfter(today);
        }).length;
      }

      return BusinessSummary(
        totalDueAmount: totalDueAmount,
        totalCustomers: customersSnapshot.size,
        totalTransactions: totalTransactions,
        todaysTransactions: todaysTransactions,
      );
    } catch (e) {
      print('Error getting business summary: $e');
      return BusinessSummary(
        totalDueAmount: 0.0,
        totalCustomers: 0,
        totalTransactions: 0,
        todaysTransactions: 0,
      );
    }
  }

  // Get top due customers
  Future<List<Customer>> getTopDueCustomers() async {
    try {
      final snapshot = await _firestore
          .collection('customers')
          .orderBy('totalDue', descending: true)
          .where('totalDue', isGreaterThan: 0)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) => Customer.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error getting top due customers: $e');
      return [];
    }
  }
}
