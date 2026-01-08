import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/notification_model.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/routes/app_pages.dart';

class NotificationController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _bindNotifications();
  }

  void _bindNotifications() {
    // Determine stream based on user login status?
    // Requirement implies user specific notifications.
    // Assuming user is logged in for this feature to meaningful.

    // We listen to all notifications and filter on client side as per request requirements,
    // or we can try to filter in query if possible, but request says "cek owner_by di array",
    // implying client side check or array-contains query.
    // However, "jika type berbeda tampilkan saya" (if type different show me) implies mixing logic.
    // It's safer to fetch mostly relevant ones or all and filter.
    // Given "collection notifications", let's listen to the collection.

    FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            final user = _authService.user.value;
            final userId = user?.id?.toString();

            if (userId == null) {
              // If not logged in, maybe show general ones?
              // Request specific logic about owner_by (user_id kita).
              // If not logged in, we can't check user_id.
              // Let's assume empty if not logged in or just general ones.
              notifications.clear();
              isLoading.value = false;
              return;
            }

            final List<NotificationModel> temp = [];

            print("Notification: Stream received ${snapshot.docs.length} docs");
            print("Notification: Current User ID: $userId");

            for (var doc in snapshot.docs) {
              try {
                final notif = NotificationModel.fromFirestore(doc);
                print(
                  "Notification: Processing doc ${doc.id}, type: ${notif.type}",
                );
                print(
                  "Notification: ownerBy: ${notif.ownerBy}, deletedBy: ${notif.deletedBy}",
                );

                // Filter Logic

                // 1. deleted_by: "jika id kita ada di deleted_by. maka hide listnya."
                if (notif.deletedBy != null &&
                    notif.deletedBy!.contains(userId)) {
                  print("Notification: Skipped ${doc.id} (deleted)");
                  continue;
                }

                // 2. type transaction: "jika type transaction maka cek owner_by di array apakah ada user_id kita."
                if (notif.type == 'transaction') {
                  if (notif.ownerBy == null ||
                      !notif.ownerBy!.contains(userId)) {
                    print(
                      "Notification: Skipped ${doc.id} (not owner of transaction)",
                    );
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

            print("Notification: Final list size: ${temp.length}");
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

  void handleNotificationTap(NotificationModel notif) {
    markAsRead(notif);

    // Navigation Logic
    if (notif.reference != null) {
      final ref = notif.reference!;
      String? type = ref['type'];
      String? uuid = ref['uuid']; // or slug

      print("Notification: Tapped with type: $type, uuid/slug: $uuid");

      if (type != null && uuid != null) {
        // Handle normal transactions
        if (type == 'tour' || type == 'homestay') {
          Get.toNamed(
            Routes.TRANSACTION_DETAIL,
            arguments: {'uuid': uuid, 'type': type},
          );
        }
        // Handle events (could be transaction or regular detail)
        // If type is explicitly 'events' (plural) from the screenshot, handle it.
        else if (type == 'events' || type == 'event') {
          // Decide if it's transaction detail or public DetailView
          // Requirement said: "reference used to move to activity example transaction/tour/uuid"
          // and "pindah ke invoice tour".
          // Ensure we map 'events' to 'event' for transaction detail if it's a transaction.

          // If it is a generic event notification (like in screenshot "Ada Event Baru"),
          // likely it should go to Event Detail, NOT Transaction Invoice.
          // However, the prompt specifically mentioned "pindah ke invoice tour yang dengan uuid tersebut".
          // But the screenshot shows "New Event".

          // Heuristic: If Notification Type is 'transaction', go to Invoice.
          // If Notification Type is 'events' (or 'info'), go to Product Detail?
          // The Prompt said: "reference tersebut digunakan untuk pindah ke activity contoh transaction/tour/uuid"

          // Let's assume for now everything goes to Transaction Detail if we can,
          // BUT "events/pandawa-beach-festival" looks like a slug for a Detail Page, not a UUID for an Order.

          // For now, I will map 'events' to 'event' and try transaction detail
          // because that was the explicit request ("pindah ke invoice").
          // Re-reading: "pindah ke invoice tour yang dengan uuid tersebut"
          // applies if it is a transaction reference.

          Get.toNamed(
            Routes.TRANSACTION_DETAIL,
            arguments: {'uuid': uuid, 'type': 'event'},
          );
        }
      }
    }
  }

  bool isRead(NotificationModel notif) {
    final userId = _authService.user.value?.id?.toString();
    if (userId == null) return false;
    return notif.readBy != null && notif.readBy!.contains(userId);
  }
}
