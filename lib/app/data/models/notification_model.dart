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
    Map<String, dynamic>? parsedRef;
    if (data['reference'] is String) {
      final parts = (data['reference'] as String).split('/');
      if (parts.length >= 2) {
        // Assuming format "type/uuid" or "collection/slug"
        // If "events/slug", type=events, uuid=slug
        parsedRef = {'type': parts[0], 'uuid': parts[1]};
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
      ownerBy: List<String>.from(data['owner_by'] ?? []),
      deletedBy: List<String>.from(data['deleted_by'] ?? []),
      readBy: List<String>.from(data['read_by'] ?? []),
      createdAt: data['created_at'], // It is a Timestamp
    );
  }
}
