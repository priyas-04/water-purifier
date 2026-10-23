import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../models/cart_item_model.dart';
import '../services/mock_data_service.dart';
import '../services/notification_service.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  OrderProvider() {
    loadOrders();
  }

  void loadOrders() {
    _orders = List.from(MockDataService.mockOrders);
    notifyListeners();
  }

  Future<OrderModel?> placeOrder({
    required UserModel user,
    required List<CartItemModel> items,
    required AddressModel shippingAddress,
    required PaymentMethod paymentMethod,
    required PaymentStatus paymentStatus,
    String? razorpayPaymentId,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    // Calculate verified total
    final isApprovedDealer = user.isApprovedDealer;
    double verifiedSubtotal = 0.0;
    final List<CartItemModel> validatedItems = [];

    for (final item in items) {
      final unitPrice = isApprovedDealer ? item.product.wholesalePrice : item.product.retailPrice;
      validatedItems.add(CartItemModel(
        product: item.product,
        quantity: item.quantity,
        unitPrice: unitPrice,
      ));
      verifiedSubtotal += (unitPrice * item.quantity);
    }

    final shipping = verifiedSubtotal > 1500 ? 0.0 : 99.0;
    final total = verifiedSubtotal + shipping;

    final newOrderId = 'ORD-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-${(1000 + _orders.length + 1)}';

    final order = OrderModel(
      id: newOrderId,
      userId: user.uid,
      userEmail: user.email,
      userName: user.fullName,
      userPhone: user.phone,
      roleAtOrder: user.role,
      items: validatedItems,
      subtotal: verifiedSubtotal,
      shippingCharge: shipping,
      totalAmount: total,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      razorpayPaymentId: razorpayPaymentId,
      orderStatus: OrderStatus.placed,
      statusHistory: [
        OrderStatusUpdate(
          status: OrderStatus.placed,
          timestamp: DateTime.now(),
          note: paymentMethod == PaymentMethod.razorpay_test
              ? 'Paid via Razorpay Test Mode ($razorpayPaymentId).'
              : 'Cash on Delivery order placed.',
        ),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _orders.insert(0, order);
    MockDataService.mockOrders.insert(0, order);

    // Trigger local push notification
    NotificationService().postLocalNotification(
      title: 'Order Placed Successfully!',
      body: 'Your AquaPure order $newOrderId for ₹${total.toStringAsFixed(0)} has been received.',
      type: 'order',
      referenceId: newOrderId,
    );

    _isLoading = false;
    notifyListeners();
    return order;
  }

  Future<bool> cancelOrder(String orderId) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index == -1) return false;

    final existing = _orders[index];
    if (!existing.canBeCancelled) return false;

    final updatedHistory = List<OrderStatusUpdate>.from(existing.statusHistory)
      ..add(OrderStatusUpdate(
        status: OrderStatus.cancelled,
        timestamp: DateTime.now(),
        note: 'Order cancelled by customer.',
      ));

    final updatedOrder = OrderModel(
      id: existing.id,
      userId: existing.userId,
      userEmail: existing.userEmail,
      userName: existing.userName,
      userPhone: existing.userPhone,
      roleAtOrder: existing.roleAtOrder,
      items: existing.items,
      subtotal: existing.subtotal,
      shippingCharge: existing.shippingCharge,
      totalAmount: existing.totalAmount,
      shippingAddress: existing.shippingAddress,
      paymentMethod: existing.paymentMethod,
      paymentStatus: existing.paymentStatus == PaymentStatus.paid ? PaymentStatus.refunded : existing.paymentStatus,
      razorpayPaymentId: existing.razorpayPaymentId,
      orderStatus: OrderStatus.cancelled,
      statusHistory: updatedHistory,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );

    _orders[index] = updatedOrder;
    MockDataService.mockOrders = List.from(_orders);

    NotificationService().postLocalNotification(
      title: 'Order Cancelled',
      body: 'Order $orderId has been cancelled. Any test refund will reflect shortly.',
      type: 'order',
      referenceId: orderId,
    );

    notifyListeners();
    return true;
  }

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
