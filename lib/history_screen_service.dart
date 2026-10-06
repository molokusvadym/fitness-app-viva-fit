import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _workoutsRef {
    final uid = _auth.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('workouts');
  }

  Future<void> addWorkout({
    required String name,
    required String type,
  }) async {
    await _workoutsRef.add({
      'name': name,
      'type': type,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final snapshot = await _workoutsRef
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => doc.data())
        .toList();
  }

  Stream<List<Map<String, dynamic>>> watchHistory() {
    return _workoutsRef
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}