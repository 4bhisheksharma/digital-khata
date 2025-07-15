import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../services/firestore_service.dart';
import '../utils/nepali_strings.dart';

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

        final transaction = Transaction(
          productName: _productNameController.text.trim(),
          price: price,
          dueAmount: dueAmount,
        );

        await Provider.of<FirestoreService>(
          context,
          listen: false,
        ).addTransaction(widget.customerId, transaction);

        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              NepaliStrings.addItem,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Product Selection Dropdown
            DropdownButtonFormField<String>(
              value: _selectedProduct,
              decoration: InputDecoration(
                labelText: NepaliStrings.selectOrTypeProduct,
                border: const OutlineInputBorder(),
              ),
              items: [
                ...NepaliStrings.commonProducts.map(
                  (product) =>
                      DropdownMenuItem(value: product, child: Text(product)),
                ),
              ],
              onChanged: _onProductSelected,
            ),
            const SizedBox(height: 16),
            // Manual Product Name Entry
            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: NepaliStrings.productName,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'कृपया सामानको नाम लेख्नुहोस्';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: NepaliStrings.price,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'कृपया मूल्य लेख्नुहोस्';
                }
                return null;
              },
              onChanged: (_) => _updateDueAmount(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dueAmountController,
              decoration: InputDecoration(
                labelText: NepaliStrings.dueAmount,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'कृपया बाँकी रकम लेख्नुहोस्';
                }
                final dueAmount = double.tryParse(value);
                final price = double.tryParse(_priceController.text);
                if (dueAmount != null && price != null && dueAmount > price) {
                  return 'बाँकी रकम कुल मूल्य भन्दा बढी हुन सक्दैन';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(NepaliStrings.save),
            ),
          ],
        ),
      ),
    );
  }
}
