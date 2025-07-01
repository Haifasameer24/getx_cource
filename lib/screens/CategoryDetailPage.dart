import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controller/task_controller.dart';
import '../models/tsks_model.dart';

class CategoryDetailPage extends StatelessWidget {
final String catName;
const CategoryDetailPage({required this.catName});
@override
  Widget build(BuildContext context){
  final TaskController taskController = Get.find<TaskController>();

  return Scaffold(
    appBar: AppBar(
      title: Text('$catName'),
    ),
    body: Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Obx(() {
          final seenIds = <String>{};
          final tasks = taskController.tasks
              .where((task) => task.cat == catName)
              .where((task) => seenIds.add(task.id))
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                ],
              ),
              SizedBox(height: 20),
              if (tasks.isEmpty)
                Center(child: Text("لا توجد مهام حالياً"))
              else
                ...tasks.map((task) => _buildTaskCard(task, context)).toList(),
            ],
          );
        }),

      ),
    ),
  );
}

Widget _buildTaskCard(TaskModel task, BuildContext context) {
  final TaskController taskController = Get.find<TaskController>();

  return Slidable(
    key: ValueKey('${task.id}_${task.createdAt.toIso8601String()}'),
    endActionPane: ActionPane(
      motion: ScrollMotion(),
      dismissible: DismissiblePane(
        onDismissed: () async {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId == null) {
            Get.snackbar("خطأ", "المستخدم غير مسجل الدخول");
            return;
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('tasks')
              .doc(task.id)
              .delete();

          taskController.tasks.remove(task);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("تم حذف المهمة '${task.name}'")),
          );
        },
      ),
      children: [
        SlidableAction(
          onPressed: (_) {},
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete_outline,
          label: "حذف",
        ),
      ],
    ),
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: Theme.of(context).brightness == Brightness.dark
  ? Colors.grey[850]
      : Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
  ],
  ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            task.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.blue),
              const SizedBox(width: 6),
              Text(
                "${task.dueDate.year}-${task.dueDate.month.toString().padLeft(2, '0')}-${task.dueDate.day.toString().padLeft(2, '0')} "
                    "${task.dueDate.hour.toString().padLeft(2, '0')}:${task.dueDate.minute.toString().padLeft(2, '0')}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  }