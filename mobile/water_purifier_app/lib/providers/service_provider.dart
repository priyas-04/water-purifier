import 'package:flutter/foundation.dart';
import '../models/service_booking_model.dart';
import '../models/user_model.dart';
import '../services/mock_data_service.dart';
import '../services/notification_service.dart';

class ServiceProvider with ChangeNotifier {
  List<ServiceBookingModel> _bookings = [];
  bool _isLoading = false;

  List<ServiceBookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  ServiceProvider() {
    loadBookings();
  }

  void loadBookings() {
    _bookings = List.from(MockDataService.mockServiceBookings);
    notifyListeners();
  }

  Future<ServiceBookingModel> createBooking({
    required UserModel user,
    required String serviceType,
    required String preferredDate,
    required String preferredTimeSlot,
    required AddressModel address,
    required String issueDescription,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    final newId = 'SRV-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-${100 + _bookings.length + 1}';

    final booking = ServiceBookingModel(
      id: newId,
      userId: user.uid,
      customerName: user.fullName,
      customerPhone: user.phone,
      serviceType: serviceType,
      preferredDate: preferredDate,
      preferredTimeSlot: preferredTimeSlot,
      address: address,
      issueDescription: issueDescription,
      status: ServiceStatus.submitted,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _bookings.insert(0, booking);
    MockDataService.mockServiceBookings.insert(0, booking);

    NotificationService().postLocalNotification(
      title: 'Service Request Received',
      body: 'Your service request for $serviceType on $preferredDate has been booked ($newId).',
      type: 'service',
      referenceId: newId,
    );

    _isLoading = false;
    notifyListeners();
    return booking;
  }
}
