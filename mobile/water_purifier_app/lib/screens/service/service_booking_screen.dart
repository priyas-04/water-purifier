import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_provider.dart';

class ServiceBookingScreen extends StatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedServiceType = AppConstants.serviceTypes.first;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTimeSlot = 'Morning (10:00 AM - 1:00 PM)';
  final _descController = TextEditingController();
  AddressModel? _selectedAddress;

  final List<String> _timeSlots = [
    'Morning (09:00 AM - 12:00 PM)',
    'Afternoon (12:00 PM - 03:00 PM)',
    'Evening (03:00 PM - 06:00 PM)',
    'Express Emergency Slot',
  ];

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user?.addresses.isNotEmpty == true) {
      _selectedAddress = auth.user!.addresses.first;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _submit() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or add a service address.')),
      );
      return;
    }

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    final booking = await serviceProvider.createBooking(
      user: auth.user!,
      serviceType: _selectedServiceType,
      preferredDate: dateStr,
      preferredTimeSlot: _selectedTimeSlot,
      address: _selectedAddress!,
      issueDescription: _descController.text.trim(),
    );

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle_outline, color: AppConstants.successGreen, size: 48),
          title: const Text('Service Booked!'),
          content: Text(
            'Your service request (${booking.id}) for $_selectedServiceType has been scheduled for $dateStr.\n\n'
            'A certified AquaPure technician will be assigned and call prior to arrival.',
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.go('/service');
              },
              child: const Text('View Service Desk'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final dateDisplay = DateFormat('EEE, dd MMMM yyyy').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Purifier Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Type Selector
              const Text('Select Service Required', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedServiceType,
                    isExpanded: true,
                    items: AppConstants.serviceTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedServiceType = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Preferred Date Picker
              const Text('Preferred Service Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: AppConstants.primaryBlue),
                          const SizedBox(width: 12),
                          Text(dateDisplay, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        ],
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Time Slot Selector
              const Text('Preferred Arrival Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTimeSlot,
                    isExpanded: true,
                    items: _timeSlots.map((slot) {
                      return DropdownMenuItem(value: slot, child: Text(slot));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedTimeSlot = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Service Address
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Service Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  TextButton(
                    onPressed: () async {
                      final selected = await context.push<AddressModel>('/select-address');
                      if (selected != null) setState(() => _selectedAddress = selected);
                    },
                    child: const Text('Change Location'),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.home_work_outlined, color: AppConstants.primaryBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedAddress?.fullAddress ?? 'No address selected',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Issue / Notes
              const Text('Describe Problem / Water Details (Optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'e.g. Water taste feels salty, TDS high, or low pressure dispensing...',
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: serviceProvider.isLoading ? null : _submit,
                child: serviceProvider.isLoading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Text('Confirm Service Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
