import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String customerId;
  final String productName;
  final double price;
  final double dueAmount;
  final DateTime date;
  final String nepaliDate;

  Transaction({
    required this.id,
    required this.customerId,
    required this.productName,
    required this.price,
    required this.dueAmount,
    required this.date,
    required this.nepaliDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'productName': productName,
      'price': price,
      'dueAmount': dueAmount,
      'date': date,
      'nepaliDate': nepaliDate,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      dueAmount: (map['dueAmount'] ?? 0).toDouble(),
      date: (map['date'] as Timestamp).toDate(),
      nepaliDate: map['nepaliDate'] ?? '',
    );
  }
}
