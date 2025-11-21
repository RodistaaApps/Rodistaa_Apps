import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../providers/notification_provider.dart';
import '../../services/mock_data.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Timer? _demoTimer;

  @override
  void initState() {
    super.initState();
    _demoTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<NotificationProvider>().pushDemoNotification();
      }
    });
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationProvider>().markAllRead(),
            child: const Text(
              'Mark all read',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final notifications = provider.notifications;
          if (notifications.isEmpty) {
            return const _EmptyNotificationsState();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Dismissible(
                key: ValueKey(notification.id),
                background: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => provider.dismiss(notification.id),
                child: _NotificationTile(
                  message: notification,
                  onTap: () => _openDetail(context, notification),
                  onMarkRead: () => provider.markRead(notification.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, NotificationMessage message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(message.title),
        content: Text(message.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.message,
    required this.onTap,
    required this.onMarkRead,
  });

  final NotificationMessage message;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    final timestamp = DateFormat('dd MMM, hh:mm a').format(message.timestamp);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryRed.withValues(alpha: 0.15),
              child: const Icon(Icons.notifications, color: AppColors.primaryRed),
            ),
            if (!message.read)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          message.title,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Times New Roman'),
            ),
            const SizedBox(height: 4),
            Text(
              timestamp,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 11,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ),
        onTap: () {
          if (!message.read) {
            onMarkRead();
          }
          onTap();
        },
      ),
    );
  }
}

class _EmptyNotificationsState extends StatelessWidget {
  const _EmptyNotificationsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.notifications_off, size: 72, color: Color(0xFFCCCCCC)),
          SizedBox(height: 8),
          Text(
            'All caught up!',
            style: TextStyle(fontFamily: 'Times New Roman', fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

