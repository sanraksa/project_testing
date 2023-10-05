// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vtech_todo/src/home/model/todo_model.dart';

import '../custom/show_dailog.dart';

class TodoController extends GetxController {
  final searchText = "".obs;
  final isSearch = false.obs;
  final isCompeleted = false.obs;
  final isDuplicate = false.obs;
  final isNull = false.obs;
  final isNoData = false.obs;
  final confirmItem = ''.obs;
  final time = ''.obs;
  final listItem = <TodoModel>[].obs;
  final todoList = <TodoModel>[].obs;

  @override
  void onReady() {
    bindTodoStream();
  }

  bindTodoStream() async {
    todoList.bindStream(_todoStream());
  }

  //firebase

  Stream<List<TodoModel>> _todoStream() {
    return FirebaseFirestore.instance
        .collection('todos')
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      final queryText = searchText.value;
      final shouldSearch = queryText.removeAllWhitespace.isNotEmpty;
      return query.docs
          .map((e) => TodoModel.fromDocumentSnapshot(documentSnapshot: e))
          .where((todo) {
        if (shouldSearch) {
          return todo.title.toLowerCase().contains(queryText.toLowerCase()) ||
              queryText.toLowerCase().contains(todo.title.toLowerCase());
        } else {
          return true;
        }
      }).toList();
    });
  }

  addTodo(TodoModel todo, BuildContext context) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('todos');

    QuerySnapshot querySnapshot =
        await collectionRef.where('title', isEqualTo: todo.title).get();

    if (querySnapshot.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('todos').add(
        {
          'title': todo.title,
          'createdDate': todo.createdDate,
          'isCompleted': false,
          'time': todo.time,
        },
      );
      isDuplicate.value = false;
    } else {
      isDuplicate.value = true;

      onShowDuplicat(context);
    }
  }

  addDuplicat(TodoModel todo) async {
    await FirebaseFirestore.instance.collection('todos').add({
      'title': todo.title,
      'createdDate': todo.createdDate,
      'time': todo.time,
      'isCompleted': false,
    });
  }

  updateTitle(String newTitle, documentId) {
    FirebaseFirestore.instance.collection('todos').doc(documentId).update(
      {
        'title': newTitle,
      },
    );
  }

  deleteTodo(String documentId) {
    FirebaseFirestore.instance.collection('todos').doc(documentId).delete();
  }

  onCompleted(int index) {
    final todos = todoList[index];
    todos.iscompleted = !todos.iscompleted!;
    todoList[index] = todos;
  }
}
