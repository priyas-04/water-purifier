import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final referralCode = user?.referralCode ?? 'AQ-PURE2026';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer & Earn'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Hero Icon & Title
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.card_giftcard, size: 64, color: Colors.amber),
            ),
            const SizedBox(height: 20),
            const Text(
              'Give ₹500, Get ₹500',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Invite friends to AquaPure. When they place their first water purifier order using your code, both of you receive a ₹500 discount voucher.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 28),

            // Referral Code Display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  const Text('YOUR UNIQUE REFERRAL CODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(
                    referralCode,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: AppConstants.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: referralCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Referral code copied to clipboard!')),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy Referral Code'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // How it works
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How It Works', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),
                  _stepRow(1, 'Share your code', 'Send your unique code via WhatsApp, SMS, or Social Media.'),
                  const SizedBox(height: 12),
                  _stepRow(2, 'Friend registers & orders', 'They get ₹500 off instantly at checkout.'),
                  const SizedBox(height: 12),
                  _stepRow(3, 'Earn your reward', 'Once their purifier is installed, your ₹500 credit is credited to your wallet.'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Referral Policy & Duplicate Guard Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Anti-fraud protection: Self-referrals and duplicate accounts are automatically detected and disqualified.',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepRow(int step, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppConstants.primaryBlue,
          child: Text(step.toString(), style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
