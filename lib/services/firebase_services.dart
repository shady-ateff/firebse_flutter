import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServicee {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // GET
  Future<List<QueryDocumentSnapshot>> getTasks() async {
    final snapshot = await firestore.collection('taskat').get();
    log(snapshot.docs.toString());
    return snapshot.docs;
  }

  // ADD
  Future<void> addTask(Map<String, dynamic> data) async {
    await firestore.collection('taskat').add(data);
    log('Task added successfully');
  }

  // UPDATE
  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    await firestore.collection('taskat').doc(taskId).update(data);
  }

  // DELETE
  Future<void> deleteTask(String taskId) async {
    await firestore.collection('taskat').doc(taskId).delete();
  }
}
