import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:godevi_app/app/modules/shared/widgets/skeletons_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/notification_model.dart';
import 'package:godevi_app/app/modules/notification/controllers/notification_controller.dart';
import 'package:intl/intl.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ListSkeleton();
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  "No notifications yet",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];
            return _buildNotificationItem(notif);
          },
        );
      }),
    );
  }

  Widget _buildNotificationItem(NotificationModel notif) {
    final bool isRead = controller.isRead(notif);
    final String type = notif.type?.toLowerCase() ?? 'info';

    return Dismissible(
      key: Key(notif.id ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        controller.deleteNotification(notif);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: isRead
              ? Border.all(color: Colors.grey.withOpacity(0.1))
              : Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => controller.handleNotificationTap(notif),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon Container
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getBackgroundColor(type),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconData(type),
                      color: _getIconColor(type),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notif.title ?? 'No Title',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: isRead
                                      ? FontWeight.w600
                                      : FontWeight.w700,
                                  fontSize: 15,
                                  color: const Color(0xFF1F2937),
                                ),
                              ),
                            ),
                            if (!isRead)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notif.subtitle ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Time Badge and Type Badge
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getTimeAgo(notif.createdAt),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String type) {
    switch (type) {
      case 'transaction':
        return Icons.receipt_long_rounded;
      case 'tours':
        return Icons.map_outlined;
      case 'tour':
        return Icons.map_outlined;
      case 'events':
        return Icons.celebration_rounded;
      case 'event':
        return Icons.celebration_rounded;
      case 'homestay':
        return Icons.bed_rounded;
      case 'webview':
        return Icons.language_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'transaction':
        return const Color(0xFF10B981); // Emerald
      case 'tours':
      case 'tour':
        return const Color(0xFF3B82F6); // Blue
      case 'events':
      case 'event':
        return const Color(0xFFF59E0B); // Amber
      case 'homestay':
        return const Color(0xFF8B5CF6); // Violet
      case 'webview':
        return const Color(0xFF64748B); // Slate
      default:
        return const Color(0xFF9CA3AF); // Gray
    }
  }

  Color _getBackgroundColor(String type) {
    return _getIconColor(type).withOpacity(0.1);
  }

  String _getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('dd MMM yyyy').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }
}
