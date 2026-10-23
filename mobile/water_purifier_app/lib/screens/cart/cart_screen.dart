import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/empty_state_view.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final items = cart.items.values.toList();
    final isApprovedDealer = auth.isApprovedDealer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Cart?'),
                    content: const Text('Are you sure you want to remove all items from your cart?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          cart.clearCart();
                          Navigator.of(ctx).pop();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppConstants.dangerRed),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Clear', style: TextStyle(color: AppConstants.dangerRed)),
            ),
        ],
      ),
      body: items.isEmpty
          ? EmptyStateView(
              icon: Icons.remove_shopping_cart_outlined,
              title: 'Your Cart is Empty',
              description: 'Looks like you haven\'t added any water purifiers or filters to your cart yet.',
              buttonText: 'Browse Catalog',
              onButtonPressed: () => context.go('/products'),
            )
          : Column(
              children: [
                // Free Shipping Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: cart.shippingCharge == 0 ? Colors.green.shade50 : Colors.blue.shade50,
                  child: Row(
                    children: [
                      Icon(
                        cart.shippingCharge == 0 ? Icons.local_shipping : Icons.info_outline,
                        size: 18,
                        color: cart.shippingCharge == 0 ? Colors.green.shade800 : Colors.blue.shade800,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cart.shippingCharge == 0
                              ? 'Congratulations! You qualify for FREE Delivery.'
                              : 'Add ₹${(1500 - cart.subtotal).toStringAsFixed(0)} more for FREE Delivery.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cart.shippingCharge == 0 ? Colors.green.shade900 : Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Cart Items List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item.product.imageUrl,
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${item.unitPrice.toStringAsFixed(0)} each',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${item.totalPrice.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppConstants.primaryBlue,
                                        ),
                                      ),
                                      // Quantity Controls
                                      Container(
                                        height: 34,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              iconSize: 16,
                                              icon: const Icon(Icons.remove),
                                              onPressed: () => cart.decrementQuantity(item.product.id),
                                            ),
                                            Text(
                                              item.quantity.toString(),
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              iconSize: 16,
                                              icon: const Icon(Icons.add),
                                              onPressed: () => cart.incrementQuantity(item.product.id),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Order Calculation Bottom Sheet
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                          Text('₹${cart.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Charges', style: TextStyle(color: Colors.grey)),
                          Text(
                            cart.shippingCharge == 0 ? 'FREE' : '₹${cart.shippingCharge.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: cart.shippingCharge == 0 ? AppConstants.successGreen : null,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                            '₹${cart.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.push('/checkout'),
                        child: Text('Proceed to Checkout (${cart.itemCount} Items)'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
