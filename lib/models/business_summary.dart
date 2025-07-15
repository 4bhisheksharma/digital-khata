class BusinessSummary {
  final int totalCustomers;
  final int totalTransactions;
  final double totalDueAmount;
  final int todaysTransactions;

  BusinessSummary({
    required this.totalCustomers,
    required this.totalTransactions,
    required this.totalDueAmount,
    required this.todaysTransactions,
  });

  factory BusinessSummary.fromMap(Map<String, dynamic> map) {
    return BusinessSummary(
      totalCustomers: map['totalCustomers'] as int,
      totalTransactions: map['totalTransactions'] as int,
      totalDueAmount: (map['totalDueAmount'] as num).toDouble(),
      todaysTransactions: map['todaysTransactions'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalCustomers': totalCustomers,
      'totalTransactions': totalTransactions,
      'totalDueAmount': totalDueAmount,
      'todaysTransactions': todaysTransactions,
    };
  }
}
