import 'package:nepali_utils/nepali_utils.dart';

class Customer {
  /// Unique 4-digit customer ID
  final String id;

  /// Customer's full name
  final String name;

  /// List of all transactions
  final List<Transaction> transactions;

  /// Total due amount
  double get totalDues =>
      transactions.fold(0, (sum, transaction) => sum + transaction.dueAmount);

  Customer({
    required this.id,
    required this.name,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];

  /// Factory method to create a Customer from a map (e.g., from Firestore)
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as String,
      name: map['name'] as String,
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

  Transaction({
    required this.productName,
    required this.price,
    required this.dueAmount,
    NepaliDateTime? date,
  }) : date = date ?? NepaliDateTime.now();

  /// Factory method to create a Transaction from a map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      productName: map['productName'] as String,
      price: (map['price'] as num).toDouble(),
      dueAmount: (map['dueAmount'] as num).toDouble(),
      date: NepaliDateTime.parse(map['date'] as String),
    );
  }

  /// Converts the Transaction object to a map
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'price': price,
      'dueAmount': dueAmount,
      'date': date.toString(),
    };
  }
}
