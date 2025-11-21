import 'package:flutter/foundation.dart';

import '../services/mock_data.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider() {
    _load();
  }

  final NotificationService _service = NotificationService.instance;
  List<NotificationMessage> _notifications = const [];
  bool _isLoading = true;

  List<NotificationMessage> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> _load() async {
    _notifications = await _service.fetchNotifications();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => _load();

  Future<void> markRead(String id) async {
    await _service.markRead(id);
    await _load();
  }

  Future<void> markAllRead() async {
    await _service.markAllRead();
    await _load();
  }

  Future<void> dismiss(String id) async {
    await _service.dismiss(id);
    await _load();
  }

  Future<void> pushDemoNotification() async {
    final timestamp = DateTime.now();
    await _service.addNotification(
      'New booking near you',
      'Fresh load opportunity posted at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
    );
    await _load();
  }
}

