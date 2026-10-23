import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../widgets/status_badge.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Tracking')),
        body: const Center(child: Text('Order not found.')),
      );
    }

    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${order.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card with Timeline
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      StatusBadge.forOrder(order.orderStatus),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStatusTimeline(order.orderStatus),
                  const Divider(height: 24),
                  Text('Placed on: $dateStr', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Status Updates History
            if (order.statusHistory.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tracking Milestones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 12),
                    ...order.statusHistory.map((sh) {
                      final timeStr = DateFormat('dd MMM, hh:mm a').format(sh.timestamp);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.circle, size: 10, color: AppConstants.primaryBlue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        sh.status.name.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      Text(timeStr, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                    ],
                                  ),
                                  if (sh.note.isNotEmpty)
                                    Text(
                                      sh.note,
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.3),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Delivery Address Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: AppConstants.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const Divider(height: 16),
                  Text('${order.userName}  •  ${order.userPhone}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(order.shippingAddress.fullAddress, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Items List
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Items in Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: item.product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 2),
                                Text('Qty: ${item.quantity}  •  ₹${item.unitPrice.toStringAsFixed(0)} each', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                              ],
                            ),
                          ),
                          Text('₹${item.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('₹${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConstants.primaryBlue)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cancel Button if permitted
            if (order.canBeCancelled)
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Cancel Order?'),
                      content: const Text('Are you sure you want to cancel this order? Any payments will be refunded.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Keep Order')),
                        ElevatedButton(
                          onPressed: () {
                            orderProvider.cancelOrder(order.id);
                            Navigator.of(ctx).pop();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppConstants.dangerRed),
                          child: const Text('Yes, Cancel Order'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.cancel_outlined, color: AppConstants.dangerRed),
                label: const Text('Cancel Order', style: TextStyle(color: AppConstants.dangerRed)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppConstants.dangerRed),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(OrderStatus currentStatus) {
    if (currentStatus == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
        child: const Row(
          children: [
            Icon(Icons.cancel, color: AppConstants.dangerRed, size: 20),
            SizedBox(width: 8),
            Text('This order was cancelled.', style: TextStyle(color: AppConstants.dangerRed, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    final steps = [
      OrderStatus.placed,
      OrderStatus.confirmed,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    final currentIndex = steps.indexOf(currentStatus);

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index % 2 == 1) {
          // Connector line
          final stepBefore = index ~/ 2;
          final isPassed = stepBefore < currentIndex;
          return Expanded(
            child: Container(
              height: 3,
              color: isPassed ? AppConstants.primaryBlue : Colors.grey.shade300,
            ),
          );
        } else {
          // Circle node
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex <= currentIndex;
          return Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? AppConstants.primaryBlue : Colors.white,
              border: Border.all(
                color: isCompleted ? AppConstants.primaryBlue : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          );
        }
      }),
    );
  }
}
