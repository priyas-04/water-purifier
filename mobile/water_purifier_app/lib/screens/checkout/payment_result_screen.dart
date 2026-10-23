import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';

class PaymentResultScreen extends StatelessWidget {
  final bool isSuccess;
  final String? paymentId;
  final String? errorMessage;

  const PaymentResultScreen({
    super.key,
    required this.isSuccess,
    this.paymentId,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle : Icons.cancel,
                  size: 72,
                  color: isSuccess ? AppConstants.successGreen : AppConstants.dangerRed,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isSuccess ? 'Payment Successful!' : 'Payment Failed',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                isSuccess
                    ? 'Your transaction in Razorpay TEST MODE was verified successfully.'
                    : (errorMessage ?? 'The payment could not be completed or was cancelled by user.'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
              ),
              if (paymentId != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Transaction Ref: $paymentId',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.grey.shade800),
                  ),
                ),
              ],
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: Text(isSuccess ? 'Continue to Home' : 'Return to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
