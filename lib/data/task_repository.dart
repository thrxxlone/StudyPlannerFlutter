import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_item.dart'; // правильний шлях
import 'package:uuid/uuid.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'tasks';
  final _uuid = Uuid();

  Future<List<TaskItem>> getTasks() async {
    final snapshot = await _firestore.collection(collectionName).get();
    return snapshot.docs.map((doc) => TaskItem.fromFirestore(doc)).toList();
  }

  Future<void> addTask(TaskItem task, {DateTime? dueDate}) async {
    final id = _uuid.v4();
    final taskWithId = task.copyWith(id: id);
    final map = taskWithId.toMap();
    if (dueDate != null) {
      map['dueDate'] = Timestamp.fromDate(dueDate);
    }
    await _firestore.collection(collectionName).doc(id).set(map);
  }

  Future<void> updateTask(TaskItem task, {DateTime? dueDate}) async {
    final map = task.toMap();
    if (dueDate != null) {
      map['dueDate'] = Timestamp.fromDate(dueDate);
    }
    await _firestore.collection(collectionName).doc(task.id).update(map);
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}
