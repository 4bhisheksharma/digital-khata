import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:nepali_utils/nepali_utils.dart';
import '../models/customer.dart';

class TestDataService {
  static Future<void> initializeTestData() async {
    final firestore = FirebaseFirestore.instance;
    final now = NepaliDateTime.now();

    // Sample customers
    final customers = [
      Customer(
        id: '1001',
        name: 'Abhishek Sharma',
        transactions: [
          Transaction(
            productName: 'Rice',
            price: 1200,
            dueAmount: 500,
            date: now,
          ),
          Transaction(
            productName: 'Wheat',
            price: 800,
            dueAmount: 300,
            date: now.subtract(const Duration(days: 1)),
          ),
        ],
      ),
      Customer(
        id: '1002',
        name: 'Ram Kumar',
        transactions: [
          Transaction(
            productName: 'Sugar',
            price: 500,
            dueAmount: 200,
            date: now,
          ),
        ],
      ),
    ];

    // Add customers to Firestore
    for (final customer in customers) {
      await firestore
          .collection('customers')
          .doc(customer.id)
          .set(customer.toMap());
    }
  }
}
