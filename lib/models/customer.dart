import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  /// Unique customer ID
  final String id;

  /// Unique 4-digit customer ID
  final String uniqueId;

  /// Customer's full name
  final String name;

  /// Customer's phone number
  final String? phone;

  /// Customer's address
  final String? address;

  /// Total due amount
  final double totalDue;

  /// List of all transactions
  final List<Transaction> transactions;

  /// Creation date in Nepali format
  final String nepaliCreatedDate;

  /// Creation timestamp
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.uniqueId,
    required this.name,
    this.phone,
    this.address,
    this.totalDue = 0.0,
    List<Transaction>? transactions,
    required this.nepaliCreatedDate,
    required this.createdAt,
  }) : transactions = transactions ?? [];

  /// Factory method to create a Customer from a DocumentSnapshot
  factory Customer.fromSnapshot(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw ArgumentError('Customer data cannot be null');
      }

      // Handle createdAt field
      DateTime parseCreatedAt() {
        final createdAt = data['createdAt'];
        if (createdAt is Timestamp) {
          return createdAt.toDate();
        } else if (createdAt is String) {
          return DateTime.parse(createdAt);
        }
        return DateTime.now();
      }

      // Parse transactions safely
      List<Transaction> parseTransactions() {
        try {
          final transactionsList = data['transactions'] as List<dynamic>?;
          if (transactionsList == null) return [];

          return transactionsList
              .map((e) => Transaction.fromMap(e as Map<String, dynamic>))
              .toList();
        } catch (e) {
          print('Error parsing transactions: $e');
          return [];
        }
      }

      return Customer(
        id: doc.id,
        uniqueId: data['uniqueId']?.toString() ?? '',
        name: data['name']?.toString() ?? '',
        phone: data['phone']?.toString(),
        address: data['address']?.toString(),
        totalDue: (data['totalDue'] as num?)?.toDouble() ?? 0.0,
        transactions: parseTransactions(),
        nepaliCreatedDate: data['nepaliCreatedDate']?.toString() ?? '',
        createdAt: parseCreatedAt(),
      );
    } catch (e) {
      print('Error creating Customer from snapshot: $e');
      rethrow;
    }
  }

  /// Factory method to create a Customer from a map
  factory Customer.fromMap(Map<String, dynamic> map) {
    try {
      // Handle createdAt field
      DateTime parseCreatedAt() {
        final createdAt = map['createdAt'];
        if (createdAt is Timestamp) {
          return createdAt.toDate();
        } else if (createdAt is String) {
          return DateTime.parse(createdAt);
        }
        return DateTime.now();
      }

      // Parse transactions safely
      List<Transaction> parseTransactions() {
        try {
          final transactionsList = map['transactions'] as List<dynamic>?;
          if (transactionsList == null) return [];

          return transactionsList
              .map((e) => Transaction.fromMap(e as Map<String, dynamic>))
              .toList();
        } catch (e) {
          print('Error parsing transactions: $e');
          return [];
        }
      }

      return Customer(
        id: map['id']?.toString() ?? '',
        uniqueId: map['uniqueId']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        phone: map['phone']?.toString(),
        address: map['address']?.toString(),
        totalDue: (map['totalDue'] as num?)?.toDouble() ?? 0.0,
        transactions: parseTransactions(),
        nepaliCreatedDate: map['nepaliCreatedDate']?.toString() ?? '',
        createdAt: parseCreatedAt(),
      );
    } catch (e) {
      print('Error creating Customer from map: $e');
      rethrow;
    }
  }

  /// Converts the Customer object to a map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uniqueId': uniqueId,
      'name': name,
      'phone': phone,
      'address': address,
      'totalDue': totalDue,
      'transactions': transactions.map((e) => e.toMap()).toList(),
      'nepaliCreatedDate': nepaliCreatedDate,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class Transaction {
  /// Transaction ID
  final String id;

  /// Product name
  final String productName;

  /// Product price
  final double price;

  /// Due amount
  final double dueAmount;

  /// Transaction date in Nepali format
  final String nepaliDate;

  /// Timestamp for the transaction
  final DateTime date;

  Transaction({
    required this.id,
    required this.productName,
    required this.price,
    required this.dueAmount,
    required this.nepaliDate,
    required this.date,
  });

  /// Factory method to create a Transaction from a map
  factory Transaction.fromMap(Map<String, dynamic>? map) {
    try {
      if (map == null) {
        throw ArgumentError('Transaction data cannot be null');
      }

      // Handle date field
      DateTime parseDate() {
        final date = map['date'];
        if (date is Timestamp) {
          return date.toDate();
        } else if (date is String) {
          return DateTime.parse(date);
        }
        return DateTime.now();
      }

      return Transaction(
        id: map['id']?.toString() ?? '',
        productName: map['productName']?.toString() ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        dueAmount: (map['dueAmount'] as num?)?.toDouble() ?? 0.0,
        nepaliDate: map['nepaliDate']?.toString() ?? '',
        date: parseDate(),
      );
    } catch (e) {
      print('Error creating Transaction from map: $e');
      rethrow;
    }
  }

  /// Converts the Transaction object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'price': price,
      'dueAmount': dueAmount,
      'nepaliDate': nepaliDate,
      'date': Timestamp.fromDate(date),
    };
  }
}
