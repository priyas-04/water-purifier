import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/razorpay_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedPayment = PaymentMethod.razorpay_test;
  AddressModel? _selectedAddress;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user?.addresses.isNotEmpty == true) {
      _selectedAddress = auth.user!.addresses.first;
    }
  }

  void _processPaymentAndPlaceOrder() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty.')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    String? paymentId;
    PaymentStatus paymentStatus = PaymentStatus.pending;

    if (_selectedPayment == PaymentMethod.razorpay_test) {
      final result = await RazorpayService().openCheckout(
        amount: cart.totalAmount,
        contact: auth.user!.phone,
        email: auth.user!.email,
        orderId: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (!result.isSuccess) {
        setState(() => _isProcessing = false);
        if (mounted) {
          context.push('/payment-result?success=false&error=${result.errorMessage ?? 'Payment cancelled'}');
        }
        return;
      }

      paymentId = result.paymentId;
      paymentStatus = PaymentStatus.paid;
    } else if (_selectedPayment == PaymentMethod.demo_mock) {
      await Future.delayed(const Duration(milliseconds: 1000));
      paymentId = 'mock_demo_${DateTime.now().millisecondsSinceEpoch}';
      paymentStatus = PaymentStatus.paid;
    } else {
      // Cash on delivery
      await Future.delayed(const Duration(milliseconds: 600));
      paymentStatus = PaymentStatus.pending;
    }

    final order = await orderProvider.placeOrder(
      user: auth.user!,
      items: cart.items.values.toList(),
      shippingAddress: _selectedAddress!,
      paymentMethod: _selectedPayment,
      paymentStatus: paymentStatus,
      razorpayPaymentId: paymentId,
    );

    setState(() => _isProcessing = false);

    if (order != null && mounted) {
      cart.clearCart();
      context.go('/order-confirmation?orderId=${order.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: AppConstants.primaryBlue, size: 20),
                          SizedBox(width: 8),
                          Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      TextButton(
                        onPressed: () async {
                          final selected = await context.push<AddressModel>('/select-address');
                          if (selected != null) {
                            setState(() => _selectedAddress = selected);
                          }
                        },
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  if (_selectedAddress != null) ...[
                    Text(
                      '${auth.user?.fullName}  •  ${auth.user?.phone}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedAddress!.fullAddress,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.3),
                    ),
                  ] else ...[
                    const Text('No address selected', style: TextStyle(color: Colors.grey)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment Methods Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),

                  // Razorpay Test Mode
                  _paymentOptionTile(
                    title: 'Razorpay Payment Gateway (TEST MODE)',
                    subtitle: 'Cards, UPI, NetBanking (Simulated Test Credentials)',
                    icon: Icons.credit_card,
                    method: PaymentMethod.razorpay_test,
                    badgeText: 'TEST MODE',
                    badgeColor: Colors.blue.shade100,
                  ),
                  const Divider(height: 16),

                  // Cash on Delivery
                  _paymentOptionTile(
                    title: 'Cash on Delivery (COD)',
                    subtitle: 'Pay cash upon delivery and installation',
                    icon: Icons.payments_outlined,
                    method: PaymentMethod.cash_on_delivery,
                  ),
                  const Divider(height: 16),

                  // Demo Instant Simulator
                  _paymentOptionTile(
                    title: 'Demo Mock Checkout',
                    subtitle: 'Instant sandbox order creation for assessment testing',
                    icon: Icons.bolt,
                    method: PaymentMethod.demo_mock,
                    badgeText: 'DEMO',
                    badgeColor: Colors.purple.shade100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Summary (${items.length} Items)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  ...items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.product.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('₹${item.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 20),
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
                        style: TextStyle(color: cart.shippingCharge == 0 ? AppConstants.successGreen : null, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        '₹${cart.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppConstants.primaryBlue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPaymentAndPlaceOrder,
            child: _isProcessing
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : Text('Place Order • ₹${cart.totalAmount.toStringAsFixed(0)}'),
          ),
        ),
      ),
    );
  }

  Widget _paymentOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required PaymentMethod method,
    String? badgeText,
    Color? badgeColor,
  }) {
    final isSelected = _selectedPayment == method;
    return InkWell(
      onTap: () => setState(() => _selectedPayment = method),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppConstants.primaryBlue : Colors.grey,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: AppConstants.primaryBlue, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: badgeColor ?? Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
