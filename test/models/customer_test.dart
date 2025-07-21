import 'package:flutter_test/flutter_test.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:digital_khata/models/customer.dart';

void main() {
  group('Customer', () {
    test('should create customer with empty transactions', () {
      final customer = Customer(id: '1234', name: 'Rame dai');

      expect(customer.id, '1234');
      expect(customer.name, 'Rame dai');
      expect(customer.transactions, isEmpty);
      expect(customer.totalDues, 0);
    });

    test('should calculate total dues correctly', () {
      final customer = Customer(
        id: '1234',
        name: 'Rame dai',
        transactions: [
          Transaction(productName: 'Product 1', price: 100, dueAmount: 50),
          Transaction(productName: 'Product 2', price: 200, dueAmount: 100),
        ],
      );

      expect(customer.totalDues, 150);
    });

    test('should convert to and from map', () {
      final date = NepaliDateTime.now();
      final originalCustomer = Customer(
        id: '1234',
        name: 'Rame dai',
        transactions: [
          Transaction(
            productName: 'Product 1',
            price: 100,
            dueAmount: 50,
            date: date,
          ),
        ],
      );

      final map = originalCustomer.toMap();
      final recreatedCustomer = Customer.fromMap(map);

      expect(recreatedCustomer.id, originalCustomer.id);
      expect(recreatedCustomer.name, originalCustomer.name);
      expect(recreatedCustomer.transactions.length, 1);
      expect(recreatedCustomer.transactions[0].productName, 'Product 1');
      expect(recreatedCustomer.transactions[0].price, 100);
      expect(recreatedCustomer.transactions[0].dueAmount, 50);
      expect(
        recreatedCustomer.transactions[0].date.toString(),
        date.toString(),
      );
    });
  });
}
