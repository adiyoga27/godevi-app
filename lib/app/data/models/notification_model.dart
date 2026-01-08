import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? id;
  String? title;
  String? subtitle; // Mapped to body in UI
  String? type;
  Map<String, dynamic>? reference;
  List<String>? ownerBy;
  List<String>? deletedBy;
  List<String>? readBy;
  Timestamp? createdAt;

  NotificationModel({
    this.id,
    this.title,
    this.subtitle,
    this.type,
    this.reference,
    this.ownerBy,
    this.deletedBy,
    this.readBy,
    this.createdAt,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Handle reference parsing (it comes as string "type/uuid")
    // Handle reference parsing (it comes as string "type/uuid" or "collection/slug")
    Map<String, dynamic>? parsedRef;
    if (data['reference'] is String) {
      final String refStr = data['reference'];
      parsedRef = {'full': refStr};

      final parts = refStr.split('/');
      if (parts.length >= 2) {
        // If "events/slug", type=events, uuid=slug
        parsedRef['type'] = parts[0];
        // Capture everything after the first slash as uuid/slug/path
        parsedRef['uuid'] = parts.sublist(1).join('/');
      }
    } else if (data['reference'] is Map) {
      parsedRef = Map<String, dynamic>.from(data['reference']);
    }

    return NotificationModel(
      id: doc.id,
      title: data['title'],
      subtitle: data['subtitle'],
      type: data['type'],
      reference: parsedRef,
      ownerBy:
          (data['owner_by'] as List?)?.map((e) => e.toString()).toList() ?? [],
      deletedBy:
          (data['deleted_by'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      readBy:
          (data['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: data['created_at'], // It is a Timestamp
    );
  }
}
