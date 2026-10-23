import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';

class DealerRegisterScreen extends StatefulWidget {
  const DealerRegisterScreen({super.key});

  @override
  State<DealerRegisterScreen> createState() => _DealerRegisterScreenState();
}

class _DealerRegisterScreenState extends State<DealerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _gstController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _gstController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final success = await auth.registerDealer(
      fullName: _nameController.text.trim(),
      companyName: _companyController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      gstNumber: _gstController.text.trim().toUpperCase(),
      businessAddress: _addressController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.hourglass_top, color: AppConstants.warningOrange, size: 48),
          title: const Text('Application Submitted'),
          content: const Text(
            'Your commercial dealer application has been submitted with status: PENDING APPROVAL.\n\n'
            'AquaPure administrators will review your GST and business credentials. Once approved, wholesale tier pricing and bulk ordering will be unlocked on your account.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.go('/home');
              },
              child: const Text('Proceed to Catalog'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dealer Partnership Application'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Highlight Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber.shade900, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Wholesale pricing is reserved for verified trade partners. All applications undergo verification before wholesale privileges are activated.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text('Authorized Representative Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Ramesh Patel',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Representative name required' : null,
                ),
                const SizedBox(height: 16),

                const Text('Company / Enterprise Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Patel Water Technologies LLP',
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Company name required' : null,
                ),
                const SizedBox(height: 16),

                const Text('Official Business Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'e.g. sales@patelwater.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (val) => val != null && val.contains('@') ? null : 'Valid email required',
                ),
                const SizedBox(height: 16),

                const Text('Business Phone / Mobile', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'e.g. +91 98220 12345',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (val) => val == null || val.trim().length < 10 ? 'Valid phone number required' : null,
                ),
                const SizedBox(height: 16),

                const Text('GSTIN Number (15 Characters)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _gstController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 29AAAAA0000A1Z5',
                    prefixIcon: Icon(Icons.receipt_long_outlined),
                  ),
                  validator: (val) => val == null || val.trim().length < 15 ? 'Enter valid 15-character GSTIN' : null,
                ),
                const SizedBox(height: 16),

                const Text('Warehouse / Business Address', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Street address, City, State, PIN',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Address is required' : null,
                ),
                const SizedBox(height: 16),

                const Text('Account Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Minimum 6 characters',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (val) => val == null || val.length < 6 ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 28),

                ElevatedButton(
                  onPressed: auth.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.darkNavy,
                  ),
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('Submit Dealer Application'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
