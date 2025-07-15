import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../services/firestore_service.dart';
import '../utils/nepali_strings.dart';

class AddCustomerForm extends StatefulWidget {
  const AddCustomerForm({super.key});

  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final firestoreService = Provider.of<FirestoreService>(
          context,
          listen: false,
        );

        // Generate a 4-digit ID
        final id = (1000 + DateTime.now().millisecondsSinceEpoch % 9000)
            .toString();

        final customer = Customer(
          id: id,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        );

        await firestoreService.addCustomer(customer);

        if (!mounted) return;
        Navigator.pop(context, customer);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Title with Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  NepaliStrings.addCustomer,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: NepaliStrings.customerName,
                prefixIcon: const Icon(Icons.person_outline),
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'कृपया ग्राहकको नाम लेख्नुहोस्';
                }
                if (value.trim().length < 3) {
                  return 'नाम कम्तिमा ३ अक्षरको हुनुपर्छ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Phone Field
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: NepaliStrings.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'कृपया १० अंकको फोन नम्बर लेख्नुहोस्';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Address Field
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: NepaliStrings.address,
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
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
                          const SizedBox(width: 8),
                          Text(NepaliStrings.save),
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
