import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vtech_todo/src/home/model/todo_model.dart';

import '../controller/todo_controller.dart';

onShowEditDialog(
    BuildContext context, TodoController todoController, TodoModel todo) {
  TextEditingController textController =
      TextEditingController(text: todo.title);

  final controller = Get.put(TodoController());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Obx(
        () => AlertDialog(
          title: const Text('Edit Item Todo'),
          content: TextFormField(
            controller: textController,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: controller.isDuplicate.value == true
                  ? 'Item Duplicate'
                  : 'Item Todo',
              labelStyle: TextStyle(
                fontSize: 14,
                color: controller.isDuplicate.value == true
                    ? Colors.red
                    : Colors.blueGrey,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: controller.isDuplicate.value == true
                      ? Colors.red
                      : Colors.blueGrey,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newText = textController.text.trim();
                if (newText.isNotEmpty) {
                  controller.updateTitle(
                    textController.text,
                    todo.documentId,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      );
    },
  );
}

onShowDuplicat(
  BuildContext context,
) {
  final controller = Get.put(TodoController());
  var nows = DateTime.now();
  var formatter = DateFormat().add_jm();
  String formattedDate = formatter.format(nows);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text(
          'Item already exists!',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.isDuplicate.value = false;
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.addDuplicat(
                TodoModel(
                    title: controller.confirmItem.value,
                    createdDate: Timestamp.now(),
                    time: formattedDate,
                    iscompleted: false),
              );
              controller.isDuplicate.value = false;
            },
            child: const Text('Comfirm'),
          ),
        ],
      );
    },
  );
}
