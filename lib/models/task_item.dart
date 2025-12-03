import 'package:cloud_firestore/cloud_firestore.dart';

class TaskItem {
  final String id;
  final String title;
  final String description;
  final String priority;
  final Timestamp? dueDate;

  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    Timestamp? dueDate,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
    };
  }

  factory TaskItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskItem(
      id: data['id'] ?? doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      priority: data['priority'] ?? '',
      dueDate: data['dueDate'] as Timestamp?,
    );
  }
}
