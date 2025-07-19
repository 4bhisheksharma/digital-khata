import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../services/firestore_service.dart';
import '../utils/nepali_strings.dart';
import '../theme/app_theme.dart';

class AddTransactionForm extends StatefulWidget {
  final String customerId;

  const AddTransactionForm({super.key, required this.customerId});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _dueAmountController = TextEditingController();
  String? _selectedProduct;
  bool _isLoading = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _dueAmountController.dispose();
    super.dispose();
  }

  void _updateDueAmount() {
    if (_priceController.text.isNotEmpty) {
      _dueAmountController.text = _priceController.text;
    }
  }

  void _onProductSelected(String? value) {
    setState(() {
      _selectedProduct = value;
      if (value != null) {
        _productNameController.text = value;
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final price = double.parse(_priceController.text);
        final dueAmount = double.parse(_dueAmountController.text);

        await Provider.of<FirestoreService>(
          context,
          listen: false,
        ).addTransaction(
          widget.customerId,
          _productNameController.text.trim(),
          price,
          dueAmount,
        );

        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_shopping_cart_rounded,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  NepaliStrings.addItem,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Product Selection Dropdown
            DropdownButtonFormField<String>(
              value: _selectedProduct,
              decoration: InputDecoration(
                labelText: NepaliStrings.selectOrTypeProduct,
                prefixIcon: Icon(
                  Icons.category_outlined,
                  color: AppTheme.primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                ...NepaliStrings.commonProducts.map(
                  (product) => DropdownMenuItem(
                    value: product,
                    child: Text(
                      product,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
              onChanged: _onProductSelected,
            ),
            const SizedBox(height: 20),
            // Manual Product Name Entry
            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: NepaliStrings.productName,
                prefixIcon: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppTheme.primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'कृपया सामानको नाम लेख्नुहोस्';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Price Field
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: NepaliStrings.price,
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  color: AppTheme.primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _updateDueAmount(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'कृपया मूल्य लेख्नुहोस्';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'कृपया मान्य मूल्य लेख्नुहोस्';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Due Amount Field
            TextFormField(
              controller: _dueAmountController,
              decoration: InputDecoration(
                labelText: NepaliStrings.dueAmount,
                prefixIcon: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppTheme.primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'कृपया बाँकी रकम लेख्नुहोस्';
                }
                final dueAmount = double.tryParse(value);
                if (dueAmount == null || dueAmount < 0) {
                  return 'कृपया मान्य बाँकी रकम लेख्नुहोस्';
                }
                final price = double.tryParse(_priceController.text) ?? 0;
                if (dueAmount > price) {
                  return 'बाँकी रकम मूल्य भन्दा बढी हुन सक्दैन';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.save_rounded),
                          const SizedBox(width: 12),
                          Text(
                            NepaliStrings.save,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
