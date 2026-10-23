import 'user_model.dart';
import 'cart_item_model.dart';

enum OrderStatus {
  placed,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

enum PaymentMethod {
  razorpay_test,
  cash_on_delivery,
  demo_mock,
}

class OrderStatusUpdate {
  final OrderStatus status;
  final DateTime timestamp;
  final String note;

  OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    required this.note,
  });

  factory OrderStatusUpdate.fromMap(Map<String, dynamic> map) {
    return OrderStatusUpdate(
      status: OrderStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'placed'),
        orElse: () => OrderStatus.placed,
      ),
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      note: map['note'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String userEmail;
  final String userName;
  final String userPhone;
  final UserRole roleAtOrder;
  final List<CartItemModel> items;
  final double subtotal;
  final double discountAmount;
  final double shippingCharge;
  final double totalAmount;
  final AddressModel shippingAddress;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final OrderStatus orderStatus;
  final List<OrderStatusUpdate> statusHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userPhone,
    required this.roleAtOrder,
    required this.items,
    required this.subtotal,
    this.discountAmount = 0.0,
    this.shippingCharge = 0.0,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    required this.orderStatus,
    this.statusHistory = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  bool get canBeCancelled =>
      orderStatus == OrderStatus.placed || orderStatus == OrderStatus.confirmed;

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      roleAtOrder: UserRole.values.firstWhere(
        (e) => e.name == (map['roleAtOrder'] ?? 'customer'),
        orElse: () => UserRole.customer,
      ),
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromSnapshot(item as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (map['discountAmount'] as num?)?.toDouble() ?? 0.0,
      shippingCharge: (map['shippingCharge'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      shippingAddress: AddressModel.fromMap(map['shippingAddress'] ?? {}),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == (map['paymentMethod'] ?? 'demo_mock'),
        orElse: () => PaymentMethod.demo_mock,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == (map['paymentStatus'] ?? 'pending'),
        orElse: () => PaymentStatus.pending,
      ),
      razorpayOrderId: map['razorpayOrderId'],
      razorpayPaymentId: map['razorpayPaymentId'],
      orderStatus: OrderStatus.values.firstWhere(
        (e) => e.name == (map['orderStatus'] ?? 'placed'),
        orElse: () => OrderStatus.placed,
      ),
      statusHistory: (map['statusHistory'] as List<dynamic>?)
              ?.map((sh) => OrderStatusUpdate.fromMap(sh as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'userPhone': userPhone,
      'roleAtOrder': roleAtOrder.name,
      'items': items.map((i) => i.toSnapshot()).toList(),
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'shippingCharge': shippingCharge,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress.toMap(),
      'paymentMethod': paymentMethod.name,
      'paymentStatus': paymentStatus.name,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'orderStatus': orderStatus.name,
      'statusHistory': statusHistory.map((s) => s.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
