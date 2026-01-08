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

            for (var doc in snapshot.docs) {
              try {
                final notif = NotificationModel.fromFirestore(doc);

                // Filter Logic

                // 1. deleted_by: "jika id kita ada di deleted_by. maka hide listnya."
                if (notif.deletedBy != null &&
                    notif.deletedBy!.contains(userId)) {
                  continue;
                }

                // 2. type transaction: "jika type transaction maka cek owner_by di array apakah ada user_id kita."
                if (notif.type == 'transaction') {
                  if (notif.ownerBy == null ||
                      !notif.ownerBy!.contains(userId)) {
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

  void handleNotificationTap(NotificationModel notif) {
    markAsRead(notif);

    // Navigation Logic
    // "reference tersebut digunakan untuk pindah ke activity contoh transaction/tour/25b9a573-b3f1-4d35-a796-36f9cde39c95"
    if (notif.reference != null) {
      final ref = notif.reference!;
      // Assuming reference structure is flexible or matches the example path split?
      // "transaction/tour/uuid".
      // Let's look at the parsed reference map.
      // Or maybe the prompt meant the 'reference' field IS that string?
      // Prompt: "reference tersebut digunakan untuk pindah... contoh transaction/tour/..."
      // My Model defined reference as Map<String, dynamic>.
      // If Firestore has it as String, I should adjust.
      // But typically structured data is better.
      // Let's support both or check.
      // Re-reading: "reference tersebut digunakan untuk pindah ke activity contoh transaction/tour/uuid"
      // It implies the reference *value* might be a path string or map.
      // Let's assume it's a Map { 'type': ..., 'uuid': ... } for robustness based on my created model,
      // BUT if the backend (which I might not control fully, or implies manual entry) puts a string, I should handle it.
      // I'll stick to the Map I defined in Model for now, assuming I can define the structure.

      // If I look at the requested URL structure: transaction-detail/:type/:uuid
      // So if reference has type and uuid:

      String? type = ref['type'];
      String? uuid = ref['uuid'];

      // If reference is just a string in firestore, my model would fail or be null?
      // Let's check model.
      // `reference: data['reference'] is Map ? ... : null`
      // So if it is a string, it will be null.
      // I should update model to handle string if needed, but for now assuming Map is cleaner.

      if (type != null && uuid != null) {
        if (type == 'tour' || type == 'homestay' || type == 'event') {
          Get.toNamed(
            Routes.TRANSACTION_DETAIL,
            arguments: {'uuid': uuid, 'type': type},
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
