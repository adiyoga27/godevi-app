import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/notification_model.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:godevi_app/app/data/models/homestay_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:flutter/material.dart'; // For CircularProgressIndicator
import 'package:godevi_app/app/routes/app_pages.dart';

class NotificationController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = true.obs;

  int get unreadCount => notifications.where((n) => !isRead(n)).length;

  StreamSubscription? _firestoreSubscription;

  @override
  void onInit() {
    super.onInit();
    _bindNotifications();
    // Re-bind (restart stream) whenever user changes (login/logout)
    ever(_authService.user, (_) => _bindNotifications());
  }

  @override
  void onClose() {
    _firestoreSubscription?.cancel();
    super.onClose();
  }

  void _bindNotifications() {
    _firestoreSubscription?.cancel();

    // If user is not logged in, just clear notifications and stop
    final user = _authService.user.value;
    final userId = user?.id?.toString();
    print(userId);

    if (userId == null) {
      notifications.clear();
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    _firestoreSubscription = FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            // Re-fetch user ID inside listener just to be safe, though specific stream is bound now
            final currentUser = _authService.user.value;
            final currentUserId = currentUser?.id?.toString();

            if (currentUserId == null) {
              notifications.clear();
              isLoading.value = false;
              return;
            }

            final List<NotificationModel> temp = [];

            print("Notification: Stream received ${snapshot.docs.length} docs");
            print("Notification: Current User ID: $currentUserId");

            for (var doc in snapshot.docs) {
              try {
                final notif = NotificationModel.fromFirestore(doc);

                // Filter Logic

                // 1. deleted_by: "jika id kita ada di deleted_by. maka hide listnya."
                if (notif.deletedBy != null &&
                    notif.deletedBy!.contains(currentUserId)) {
                  continue;
                }

                // 2. type transaction: "jika type transaction maka cek owner_by di array apakah ada user_id kita."
                if (notif.type == 'transaction') {
                  if (notif.ownerBy == null ||
                      !notif.ownerBy!.contains(currentUserId)) {
                    continue;
                  }
                }

                // "jika type berbeda tampilkan saya di list notifikasi"
                // -> Implying if NOT transaction, just show it (unless deleted).

                temp.add(notif);
              } catch (e) {
                print("Error parsing notification ${doc.id}: $e");
              }
            }

            notifications.assignAll(temp);
            isLoading.value = false;
          },
          onError: (error) {
            print("Error streaming notifications: $error");
            isLoading.value = false;
          },
        );
  }

  Future<void> markAsRead(NotificationModel notif) async {
    final userId = _authService.user.value?.id?.toString();
    if (userId == null || notif.id == null) return;

    if (notif.readBy != null && notif.readBy!.contains(userId)) return;

    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notif.id)
          .update({
            'read_by': FieldValue.arrayUnion([userId]),
          });
    } catch (e) {
      print("Error marking as read: $e");
    }
  }

  Future<void> deleteNotification(NotificationModel notif) async {
    final userId = _authService.user.value?.id?.toString();
    if (userId == null || notif.id == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notif.id)
          .update({
            'deleted_by': FieldValue.arrayUnion([userId]),
          });
      // List will auto-update due to stream snapshot
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  void handleNotificationTap(NotificationModel notif) {
    if (notif.id != null && !isRead(notif)) {
      markAsRead(notif);
    }

    if (notif.reference != null) {
      final ref = notif.reference!;
      String? type = ref['type'];
      String? slug =
          ref['uuid']; // Assuming 'uuid' holds the slug for these types

      print("Notification: Tapped with type: $type, slug: $slug");

      if (type != null && slug != null) {
        // Check if the notification ITSELF is a transaction notification
        // If so, the reference points to a transaction detail
        if (notif.type == 'transaction') {
          // Use the full reference string as the API URL
          // 'full' was added to parsedRef in NotificationModel
          String? apiUrl = notif.reference?['full'];

          if (apiUrl != null) {
            Get.toNamed(
              Routes.TRANSACTION_DETAIL,
              arguments: {'api_url': apiUrl},
            );
            return;
          }

          // Fallback if 'full' missing (e.g., from old model parsing, though unlikely now)
          Get.toNamed(
            Routes.TRANSACTION_DETAIL,
            arguments: {'type': type, 'uuid': slug},
          );
          return;
        }

        // Otherwise checking reference type for generic navigation
        if (type == 'transaction') {
          // Fallback if reference type says transaction but notif.type didn't catch it
          // Unlikely if logic is consistent, but keep safe.
        } else if (type == 'webview') {
          // Handle webview navigation
          // Assuming slug/uuid contains the URL
          if (slug.isNotEmpty) {
            Get.to(
              () => Scaffold(
                appBar: AppBar(title: const Text('Webview')),
                body: Center(child: Text('Open: $slug')),
              ),
            );
          }
        } else if (type == 'events' || type == 'homestay' || type == 'tours') {
          _fetchAndNavigateToDetail(type, slug);
        } else if (type == 'tour') {
          // Fallback for 'tour' singular if used
          _fetchAndNavigateToDetail('tours', slug);
        } else if (type == 'event') {
          _fetchAndNavigateToDetail('events', slug);
        }
      }
    }
  }

  Future<void> _fetchAndNavigateToDetail(String type, String slug) async {
    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      Response response;
      PackageModel? package;

      if (type == 'events') {
        response = await _apiProvider.getEventBySlug(slug);
      } else if (type == 'homestay') {
        response = await _apiProvider.getHomestayBySlug(slug);
      } else {
        // tours
        response = await _apiProvider.getTourBySlug(slug);
      }

      Get.back(); // Close loading dialog

      // Some endpoints might return just {data: ...} without status: true
      final body = response.body;
      final isSuccess =
          response.statusCode == 200 &&
          (body['status'] == true || body['data'] != null);

      if (isSuccess) {
        final data = body['data'];

        if (type == 'homestay') {
          final homestay = HomestayModel.fromJson(data);
          package = homestay.toPackageModel();
        } else {
          // Events and Tours can be mapped to PackageModel directly (or ensure fields align)
          // DetailView uses PackageModel.
          // Note: PackageModel.fromJson handles 'date_event' etc.
          package = PackageModel.fromJson(data);
          // Ensure type is set correctly for DetailView logic
          if (type == 'events') package.type = 'event';
          if (type == 'tours') package.type = 'tour';
        }

        Get.toNamed(Routes.DETAIL, arguments: package);
      } else {
        Get.snackbar(
          "Error",
          "Failed to load details: ${response.body['message']}",
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      print("Error fetching detail: $e");
      Get.snackbar("Error", "An error occurred");
    }
  }

  bool isRead(NotificationModel notif) {
    final userId = _authService.user.value?.id?.toString();
    if (userId == null) return false;
    return notif.readBy != null && notif.readBy!.contains(userId);
  }
}
