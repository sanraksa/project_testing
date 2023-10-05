import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? documentId;
  late String title;
  late Timestamp? createdDate;
  late String? time;
  bool? iscompleted;

  TodoModel({
    required this.title,
    this.documentId,
    this.iscompleted,
    this.createdDate,
    this.time,
  });

  TodoModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    documentId = documentSnapshot.id;
    title = documentSnapshot["title"];
    time = documentSnapshot['time'];
    createdDate = documentSnapshot['createdDate'];
    iscompleted = documentSnapshot['isCompleted'];
  }
}
