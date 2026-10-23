import 'package:flutter/material.dart';
import '../../core/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Customer Care'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Support Cards
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
                  const Text('24x7 Support Channels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),
                  _contactRow(
                    icon: Icons.phone_in_talk,
                    title: 'Toll-Free Helpline',
                    subtitle: '1800-266-AQUA (1800 266 2782)',
                    color: Colors.green,
                  ),
                  const Divider(height: 20),
                  _contactRow(
                    icon: Icons.email_outlined,
                    title: 'Email Support Desk',
                    subtitle: 'support@aquapure.com',
                    color: Colors.blue,
                  ),
                  const Divider(height: 20),
                  _contactRow(
                    icon: Icons.chat_bubble_outline,
                    title: 'WhatsApp Concierge',
                    subtitle: '+91 98765 43210 (Quick Resolution)',
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FAQs
            const Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _faqCard(
              question: 'How often should I change my RO filters?',
              answer: 'Sediment and pre-carbon filters should be replaced every 6 months. Reverse Osmosis (RO) membranes typically last 12-24 months depending on incoming water salinity and TDS.',
            ),
            _faqCard(
              question: 'How do I know my current TDS level?',
              answer: 'AquaPure Smart IoT purifiers display real-time output TDS on their front LED ring. For manual purifiers, you can book a free TDS water quality audit via the Service Desk tab.',
            ),
            _faqCard(
              question: 'What is the Dealer Wholesale Program?',
              answer: 'Commercial water appliance traders, plumbers, and distributors can register for dealer access. Upon admin verification of your GST, you receive 25-35% wholesale discounts on bulk carton orders.',
            ),
            _faqCard(
              question: 'Is installation included with purchase?',
              answer: 'Yes! All AquaPure domestic and commercial water purifiers include standard complimentary installation by a certified service engineer within 48 hours of delivery.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _faqCard({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
