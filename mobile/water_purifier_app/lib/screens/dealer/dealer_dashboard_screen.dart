import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/user_model.dart';
import '../../widgets/status_badge.dart';

class DealerDashboardScreen extends StatelessWidget {
  const DealerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    final user = auth.user;
    final isApproved = auth.isApprovedDealer;
    final isPending = auth.isPendingDealer;

    final dealerOrders = orderProvider.orders.where((o) => o.roleAtOrder == UserRole.dealer).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dealer Wholesale Hub'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isApproved ? Colors.green.shade300 : Colors.amber.shade300,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user?.companyName ?? 'Commercial Partner',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      StatusBadge.forDealer(user?.dealerStatus ?? DealerStatus.pending),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'GSTIN: ${user?.gstNumber ?? '29AAAAA0000A1Z5'}',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const Divider(height: 20),
                  Text(
                    isApproved
                        ? ' Verified Trade Partner: Wholesale pricing is unlocked across all 60 systems, spare parts, and filters. Minimum bulk quantities apply.'
                        : '⏳ Application Under Review: Your business documents are currently being verified by the AquaPure Admin team. Wholesale prices will activate upon approval.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isApproved ? Colors.green.shade900 : Colors.amber.shade900,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Wholesale Metrics Summary
            Row(
              children: [
                Expanded(
                  child: _metricBox(
                    label: 'Wholesale Discount',
                    value: isApproved ? '28% - 35%' : 'Pending',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricBox(
                    label: 'Trade Orders Placed',
                    value: dealerOrders.length.toString(),
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Wholesale Ordering Action
            if (isApproved) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppConstants.darkNavy, Color(0xFF1E3A8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ready to Restock?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('Explore pumps, membranes, and complete purifiers at dealer wholesale rates.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        productProvider.setCategory('all');
                        context.go('/products');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.accentCyan,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(110, 36),
                      ),
                      child: const Text('Shop Wholesale', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Trade Orders History Section
            const Text('Wholesale Order History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            if (dealerOrders.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        'No Wholesale Orders Yet',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isApproved
                            ? 'Start by placing your first trade order from the catalogue.'
                            : 'Order placement will be enabled once your dealer application is approved.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...dealerOrders.map((order) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    subtitle: Text('${order.items.length} items • ₹${order.totalAmount.toStringAsFixed(0)}'),
                    trailing: StatusBadge.forOrder(order.orderStatus),
                    onTap: () => context.push('/order/${order.id}'),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _metricBox({required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
