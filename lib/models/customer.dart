import 'package:nepali_utils/nepali_utils.dart';

class Customer {
  /// Unique 4-digit customer ID
  final String id;

  /// Customer's full name
  final String name;

  /// Customer's phone number
  final String? phone;

  /// Customer's address
  final String? address;

  /// List of all transactions
  final List<Transaction> transactions;

  /// Total due amount
  double get totalDues =>
      transactions.fold(0.0, (sum, transaction) => sum + transaction.dueAmount);

  Customer({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];

  /// Factory method to create a Customer from a map (e.g., from Firestore)
  factory Customer.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('Customer data cannot be null');
    }

    return Customer(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString(),
      address: map['address']?.toString(),
      transactions:
          (map['transactions'] as List<dynamic>?)
              ?.map((e) => Transaction.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Converts the Customer object to a map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'transactions': transactions.map((e) => e.toMap()).toList(),
    };
  }
}

class Transaction {
  /// Product name
  final String productName;

  /// Product price
  final double price;

  /// Due amount
  final double dueAmount;

  /// Transaction date in Nepali format
  final NepaliDateTime date;

  /// Timestamp for the transaction
  final DateTime timestamp;

  Transaction({
    required this.productName,
    required this.price,
    required this.dueAmount,
    NepaliDateTime? date,
    DateTime? timestamp,
  }) : date = date ?? NepaliDateTime.now(),
       timestamp = timestamp ?? DateTime.now();

  /// Factory method to create a Transaction from a map
  factory Transaction.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('Transaction data cannot be null');
    }

    // Handle date conversion safely
    NepaliDateTime parseDate() {
      try {
        return NepaliDateTime.parse(map['date']?.toString() ?? '');
      } catch (e) {
        return NepaliDateTime.now();
      }
    }

    // Handle timestamp conversion safely
    DateTime parseTimestamp() {
      try {
        final timestamp = map['timestamp'];
        if (timestamp is int) {
          return DateTime.fromMillisecondsSinceEpoch(timestamp);
        }
        return DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }

    return Transaction(
      productName: map['productName']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      dueAmount: (map['dueAmount'] as num?)?.toDouble() ?? 0.0,
      date: parseDate(),
      timestamp: parseTimestamp(),
    );
  }

  /// Converts the Transaction object to a map
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'price': price,
      'dueAmount': dueAmount,
      'date': date.toString(),
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}
