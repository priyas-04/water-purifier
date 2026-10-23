import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/order_provider.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state_view.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: orders.isEmpty
          ? EmptyStateView(
              icon: Icons.receipt_long_outlined,
              title: 'No Orders Yet',
              description: 'You have not placed any orders yet. Discover our latest water systems today!',
              buttonText: 'Browse Catalog',
              onButtonPressed: () => context.go('/products'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = orders[index];
                final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt);

                return Card(
                  child: InkWell(
                    onTap: () => context.push('/order/${order.id}'),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: ID and Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              StatusBadge.forOrder(order.orderStatus),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Items count and summary
                          Text(
                            '${order.items.length} item(s): ${order.items.map((i) => i.product.name).join(', ')}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.3),
                          ),
                          const Divider(height: 20),

                          // Footer: Total & Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dateStr,
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    order.paymentMethod == PaymentMethod.razorpay_test
                                        ? 'Razorpay Test Mode (Paid)'
                                        : 'Cash on Delivery',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: order.paymentStatus == PaymentStatus.paid ? AppConstants.successGreen : Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '₹${order.totalAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
