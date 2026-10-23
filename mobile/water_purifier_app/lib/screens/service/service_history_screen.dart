import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/service_provider.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state_view.dart';

class ServiceHistoryScreen extends StatelessWidget {
  const ServiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final bookings = serviceProvider.bookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service & Maintenance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Service Request',
            onPressed: () => context.push('/service-booking'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service CTA Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppConstants.primaryBlue, AppConstants.accentCyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Certified Purifier Care',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Genuine filter replacements, sanitization, and TDS calibration at your doorstep.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.push('/service-booking'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppConstants.primaryBlue,
                            minimumSize: const Size(120, 36),
                          ),
                          child: const Text('Book Technician', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.support_agent, color: Colors.white, size: 56),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('My Service Bookings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            if (bookings.isEmpty)
              EmptyStateView(
                icon: Icons.handyman_outlined,
                title: 'No Service Requests',
                description: 'You have no scheduled maintenance appointments.',
                buttonText: 'Book Service',
                onButtonPressed: () => context.push('/service-booking'),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Container(
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
                            Text(
                              booking.serviceType,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            StatusBadge.forService(booking.status),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Request ID: ${booking.id}',
                          style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const Divider(height: 18),
                        Row(
                          children: [
                            const Icon(Icons.event, size: 16, color: AppConstants.primaryBlue),
                            const SizedBox(width: 6),
                            Text(
                              '${booking.preferredDate}  •  ${booking.preferredTimeSlot}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                booking.address.fullAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                              ),
                            ),
                          ],
                        ),
                        if (booking.technicianName != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.engineering, size: 20, color: AppConstants.primaryBlue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Technician: ${booking.technicianName}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      Text(
                                        'Contact: ${booking.technicianPhone}',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
