import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/location_service.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();
  List<AddressModel> _searchResults = [];
  bool _isSearching = false;

  void _searchLocation(String query) async {
    if (query.trim().length < 3) return;
    setState(() => _isSearching = true);
    final results = await LocationService.searchAddress(query);
    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  void _showAddAddressDialog() {
    final labelCtrl = TextEditingController(text: 'Home');
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController(text: 'Bangalore');
    final stateCtrl = TextEditingController(text: 'Karnataka');
    final pinCtrl = TextEditingController(text: '560001');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: labelCtrl,
                decoration: const InputDecoration(labelText: 'Address Label (Home, Office, Warehouse)'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: streetCtrl,
                decoration: const InputDecoration(labelText: 'Flat / House / Street Name'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cityCtrl,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: pinCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'PIN Code'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (streetCtrl.text.trim().isEmpty) return;
                  final newAddr = AddressModel(
                    id: 'addr-${DateTime.now().millisecondsSinceEpoch}',
                    label: labelCtrl.text.trim(),
                    street: streetCtrl.text.trim(),
                    city: cityCtrl.text.trim(),
                    state: stateCtrl.text.trim(),
                    postalCode: pinCtrl.text.trim(),
                  );
                  Provider.of<AuthProvider>(context, listen: false).addAddress(newAddr);
                  Navigator.of(ctx).pop();
                },
                child: const Text('Save Address'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final addresses = auth.user?.addresses ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Delivery Address'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // OpenStreetMap Search Bar
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search area with OpenStreetMap...',
                  prefixIcon: const Icon(Icons.search, color: AppConstants.primaryBlue),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  suffixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () => _searchLocation(_searchController.text),
                        ),
                ),
                onSubmitted: _searchLocation,
              ),
            ),

            if (_searchResults.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Search Results (OpenStreetMap)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              ..._searchResults.map((result) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: AppConstants.accentCyan),
                    title: Text(result.street, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('${result.city}, ${result.state} - ${result.postalCode}'),
                    trailing: const Text('Select', style: TextStyle(color: AppConstants.primaryBlue, fontWeight: FontWeight.bold)),
                    onTap: () {
                      auth.addAddress(result);
                      setState(() {
                        _searchResults.clear();
                        _searchController.clear();
                      });
                    },
                  ),
                );
              }),
            ],

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Saved Addresses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _showAddAddressDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final addr = addresses[index];
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppConstants.primaryBlue : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? AppConstants.primaryBlue : Colors.grey,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    addr.label,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  if (addr.isDefault) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text('DEFAULT', style: TextStyle(fontSize: 9, color: AppConstants.primaryBlue, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(addr.street, style: const TextStyle(fontSize: 13)),
                              Text(
                                '${addr.city}, ${addr.state} - ${addr.postalCode}',
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: addresses.isNotEmpty
                ? () {
                    context.pop(addresses[_selectedIndex]);
                  }
                : null,
            child: const Text('Confirm Delivery Address'),
          ),
        ),
      ),
    );
  }
}
