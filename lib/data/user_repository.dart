import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'users';

  Future<void> createUserInFirestore(String name, String email) async {
    final docRef = _firestore.collection(collectionName).doc(email); // email як унікальний ключ
    await docRef.set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final doc = await _firestore.collection(collectionName).doc(email).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }
}
