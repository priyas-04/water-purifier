import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants.dart';
import '../../models/notification_model.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/empty_state_view.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _notifications = List.from(MockDataService.mockNotifications);
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
      MockDataService.mockNotifications = List.from(_notifications);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? const EmptyStateView(
              icon: Icons.notifications_off_outlined,
              title: 'No Notifications',
              description: 'You\'re all caught up! Order status updates and service alerts will appear here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                final timeStr = DateFormat('dd MMM, hh:mm a').format(notif.createdAt);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: notif.isRead ? Theme.of(context).cardColor : Colors.blue.shade50.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: notif.isRead ? Colors.grey.shade200 : AppConstants.primaryBlue.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getNotificationColor(notif.type).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_getNotificationIcon(notif.type), color: _getNotificationColor(notif.type), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notif.title,
                                  style: TextStyle(
                                    fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                if (!notif.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppConstants.primaryBlue,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif.body,
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.3),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              timeStr,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'service':
        return Icons.handyman_outlined;
      case 'dealer':
        return Icons.verified_user_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'order':
        return AppConstants.primaryBlue;
      case 'service':
        return Colors.teal;
      case 'dealer':
        return Colors.purple;
      default:
        return AppConstants.accentCyan;
    }
  }
}
