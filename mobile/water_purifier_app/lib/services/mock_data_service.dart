import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/service_booking_model.dart';
import '../models/notification_model.dart';

class MockDataService {
  static List<ProductModel> cachedProducts = [];
  static UserModel? currentUser;
  static List<OrderModel> mockOrders = [];
  static List<ServiceBookingModel> mockServiceBookings = [];
  static List<NotificationModel> mockNotifications = [];

  static Future<List<ProductModel>> loadProducts() async {
    if (cachedProducts.isNotEmpty) return cachedProducts;
    try {
      final jsonString = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      cachedProducts = jsonList.map((item) => ProductModel.fromJson(item)).toList();
    } catch (e) {
      print('Error reading assets/data/products.json: $e');
    }
    return cachedProducts;
  }

  static void initializeDemoUser({UserRole role = UserRole.customer, DealerStatus dealerStatus = DealerStatus.none}) {
    currentUser = UserModel(
      uid: 'demo-user-101',
      email: role == UserRole.dealer ? 'dealer@aquapure.com' : 'rahul.sharma@example.com',
      fullName: role == UserRole.dealer ? 'AquaPure Solutions Ltd.' : 'Rahul Sharma',
      phone: '+91 98765 43210',
      role: role,
      dealerStatus: dealerStatus,
      companyName: role == UserRole.dealer ? 'AquaPure Solutions Ltd.' : null,
      gstNumber: role == UserRole.dealer ? '29AAAAA0000A1Z5' : null,
      businessAddress: role == UserRole.dealer ? 'Plot 42, Industrial Area, Bangalore, Karnataka' : null,
      referralCode: 'AQ-RAHUL500',
      addresses: [
        AddressModel(
          id: 'addr-1',
          label: 'Home',
          street: 'Flat 402, Green Glen Layout, Bellandur',
          city: 'Bangalore',
          state: 'Karnataka',
          postalCode: '560103',
          isDefault: true,
        ),
        AddressModel(
          id: 'addr-2',
          label: 'Office',
          street: 'Ground Floor, Tech Park Campus, Outer Ring Road',
          city: 'Bangalore',
          state: 'Karnataka',
          postalCode: '560103',
          isDefault: false,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );

    // Initial Mock Orders
    mockOrders = [
      OrderModel(
        id: 'ORD-20261020-001',
        userId: currentUser!.uid,
        userEmail: currentUser!.email,
        userName: currentUser!.fullName,
        userPhone: currentUser!.phone,
        roleAtOrder: role,
        items: [
          CartItemModel(
            product: cachedProducts.isNotEmpty ? cachedProducts[0] : ProductModel(
              id: 'AP-RO-001',
              name: 'AquaPure Copper Pro RO+UV+UF+TDS Water Purifier',
              category: 'purifier',
              shortDescription: 'Advanced 8-stage purification',
              detailedDescription: '',
              retailPrice: 18499,
              wholesalePrice: 13200,
              stockQuantity: 42,
              imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=800&q=80',
            ),
            quantity: 1,
            unitPrice: role == UserRole.dealer && dealerStatus == DealerStatus.approved ? 13200 : 18499,
          ),
        ],
        subtotal: role == UserRole.dealer && dealerStatus == DealerStatus.approved ? 13200 : 18499,
        shippingCharge: 0,
        totalAmount: role == UserRole.dealer && dealerStatus == DealerStatus.approved ? 13200 : 18499,
        shippingAddress: currentUser!.addresses.first,
        paymentMethod: PaymentMethod.razorpay_test,
        paymentStatus: PaymentStatus.paid,
        razorpayPaymentId: 'pay_test_99214A',
        orderStatus: OrderStatus.processing,
        statusHistory: [
          OrderStatusUpdate(
            status: OrderStatus.placed,
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            note: 'Order successfully placed via Razorpay Test Mode.',
          ),
          OrderStatusUpdate(
            status: OrderStatus.confirmed,
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 20)),
            note: 'Payment verified and order confirmed by AquaPure Fulfillment Desk.',
          ),
          OrderStatusUpdate(
            status: OrderStatus.processing,
            timestamp: DateTime.now().subtract(const Duration(hours: 14)),
            note: 'Items allocated and staged for dispatch.',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 14)),
      ),
    ];

    // Initial Mock Service Bookings
    mockServiceBookings = [
      ServiceBookingModel(
        id: 'SRV-20261015-08',
        userId: currentUser!.uid,
        customerName: currentUser!.fullName,
        customerPhone: currentUser!.phone,
        serviceType: 'Routine Maintenance',
        preferredDate: '2026-10-25',
        preferredTimeSlot: 'Morning (10:00 AM - 1:00 PM)',
        address: currentUser!.addresses.first,
        issueDescription: 'Semi-annual filter inspection and TDS calibration.',
        status: ServiceStatus.technician_assigned,
        technicianName: 'Suresh Kumar',
        technicianPhone: '+91 94488 12345',
        serviceNotes: 'Technician assigned with calibration kit and replacement sediment filter.',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    // Initial Mock Notifications
    mockNotifications = [
      NotificationModel(
        id: 'notif-1',
        userId: currentUser!.uid,
        title: 'Order Status Update',
        body: 'Your AquaPure Copper Pro order is now processing and will dispatch shortly.',
        type: 'order',
        referenceId: 'ORD-20261020-001',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 14)),
      ),
      NotificationModel(
        id: 'notif-2',
        userId: currentUser!.uid,
        title: 'Service Technician Assigned',
        body: 'Technician Suresh Kumar (+91 94488 12345) is scheduled for your maintenance on 25th Oct.',
        type: 'service',
        referenceId: 'SRV-20261015-08',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: 'notif-3',
        userId: currentUser!.uid,
        title: 'Welcome to AquaPure',
        body: 'Enjoy pure, healthy alkaline hydration. Explore our 60+ water purification systems.',
        type: 'promo',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }
}
