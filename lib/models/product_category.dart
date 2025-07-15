class ProductCategory {
  final String name;
  final String icon;

  const ProductCategory({required this.name, required this.icon});
}

class NepaliCategories {
  static const List<ProductCategory> categories = [
    ProductCategory(name: 'किराना', icon: '🛒'),
    ProductCategory(name: 'लुगा', icon: '👕'),
    ProductCategory(name: 'भाँडा', icon: '🍳'),
    ProductCategory(name: 'इलेक्ट्रोनिक्स', icon: '📱'),
    ProductCategory(name: 'स्टेशनरी', icon: '📚'),
    ProductCategory(name: 'कस्मेटिक', icon: '💄'),
    ProductCategory(name: 'औषधि', icon: '💊'),
    ProductCategory(name: 'अन्य', icon: '📦'),
  ];
}
