import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? id;
  String? title;
  String? body;
  String? type; // 'transaction', 'info', etc.
  String? image;
  Map<String, dynamic>? reference; // e.g., {'uuid': '...', 'type': 'tour'}
  List<String>? ownerBy; // List of user IDs who should see this
  List<String>? deletedBy; // List of user IDs who deleted this
  List<String>? readBy; // List of user IDs who read this
  Timestamp? createdAt;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.type,
    this.image,
    this.reference,
    this.ownerBy,
    this.deletedBy,
    this.readBy,
    this.createdAt,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'],
      body: data['body'],
      type: data['type'],
      image: data['image'],
      reference: data['reference'] is Map
          ? Map<String, dynamic>.from(data['reference'])
          : null,
      ownerBy: List<String>.from(data['owner_by'] ?? []),
      deletedBy: List<String>.from(data['deleted_by'] ?? []),
      readBy: List<String>.from(data['read_by'] ?? []),
      createdAt: data['created_at'],
    );
  }
}
