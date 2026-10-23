import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _notificationStreamController = StreamController<NotificationModel>.broadcast();
  Stream<NotificationModel> get notificationStream => _notificationStreamController.stream;

  Future<void> initialize() async {
    // In live Firebase environment, FirebaseMessaging.instance.requestPermission() is called.
    debugPrint('AquaPure NotificationService initialized.');
  }

  void postLocalNotification({
    required String title,
    required String body,
    required String type,
    String? referenceId,
  }) {
    final notif = NotificationModel(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current-user',
      title: title,
      body: body,
      type: type,
      referenceId: referenceId,
      isRead: false,
      createdAt: DateTime.now(),
    );
    _notificationStreamController.add(notif);
  }

  void dispose() {
    _notificationStreamController.close();
  }
}
