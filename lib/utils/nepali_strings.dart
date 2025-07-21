class NepaliStrings {
  static const String appName = 'Digital खाता';
  static const String tagline = 'व्यापार सजिलो बनाउनुहोस्';
  static const String search = 'खोज्नुहोस्...';
  static const String addCustomer = 'नयाँ ग्राहक';
  static const String addItem = 'नयाँ सामान';
  static const String totalDue = 'कुल बाँकी';
  static const String transactions = 'कारोबारहरू';
  static const String price = 'मूल्य';
  static const String dueAmount = 'बाँकी रकम';
  static const String save = 'सुरक्षित गर्नुहोस्';
  static const String cancel = 'रद्द गर्नुहोस्';
  static const String customerName = 'ग्राहकको नाम';
  static const String phone = 'फोन नम्बर';
  static const String address = 'ठेगाना';
  static const String productName = 'सामानको नाम';
  static const String selectOrTypeProduct =
      'सामान छान्नुहोस् वा टाइप गर्नुहोस्';

  // Navigation
  static const String home = 'गृह';
  static const String topDue = 'बाँकी रहेको';
  static const String reports = 'प्रतिवेदन';
  static const String settings = 'सेटिङ्स';

  // Reports
  static const String totalCustomers = 'जम्मा ग्राहकहरू';
  static const String totalTransactions = 'जम्मा कारोबारहरू';
  static const String todaysTransactions = 'आजको कारोबारहरू';
  static const String noDueCustomers = 'कुनै बाँकी रकम छैन';

  // Settings
  static const String businessSettings = 'व्यापार सेटिङ्स';
  static const String businessName = 'व्यापारको नाम';
  static const String businessAddress = 'व्यापारको ठेगाना';
  static const String appSettings = 'एप सेटिङ्स';
  static const String notifications = 'सूचनाहरू';
  static const String backupData = 'डाटा ब्याकअप';
  static const String lastBackup = 'अन्तिम ब्याकअप: कहिल्यै गरिएको छैन';
  static const String about = 'एपको बारेमा';
  static const String version = 'संस्करण';
  static const String privacy = 'गोपनीयता नीति';
  static const String help = 'मद्दत';

  // Common products that appear in dropdown
  static const List<String> commonProducts = [
    'चामल',
    'दाल',
    'चिनी',
    'तेल',
    'मैदा',
    'नुन',
    'चाउचाउ',
    'बिस्कुट',
    'साबुन',
    'दूध',
    'ब्रेड',
    'अन्डा',
  ];

  static String formatCurrency(double amount) {
    return 'रू ${amount.toStringAsFixed(2)}';
  }
}
