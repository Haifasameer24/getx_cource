import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/addCatgory_controller.dart';
import '../controller/task_controller.dart';
import '../models/tsks_model.dart';

class MyTask extends StatelessWidget {
  final TaskController taskController = Get.find<TaskController>();
  final categoryController = Get.put(CategoryController());

  final List<String> statusOption = ["inProgress"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Obx(() {
        final seenIds = <String>{};
        final tasks = taskController.filteredTasks
            .where((task) => task.status == TaskStatus.upcoming)
            .where((task) => seenIds.add(task.id)) // Remove duplicates
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: "RobotoSlab",
              ),
            ),
            SizedBox(height: 20),
            if (tasks.isEmpty)
              Center(child: Text("لا توجد مهام حالياً", style: theme.textTheme.bodyMedium))
            else
              ...tasks.map((task) => _buildTaskCard(task, context)).toList(),
          ],
        );
      }),
    );
  }

  Widget _buildTaskCard(TaskModel task, BuildContext context) {
    return Slidable(
      key: ValueKey('${task.id}_${task.createdAt.toIso8601String()}'),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () async {
            final userId = GetStorage().read("id");
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
            onPressed: (_) async {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId == null) {
                Get.snackbar("خطأ", "المستخدم غير مسجل الدخول");
                return;
              }

              try {
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
              } catch (e) {
                Get.snackbar("خطأ أثناء الحذف", e.toString());
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: "Delete",
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              task.description,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              "Category : ${task.cat}",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: Colors.blue),
                    SizedBox(width: 6),
                    Text(
                      "${task.dueDate.year}-${task.dueDate.month.toString().padLeft(2, '0')}-${task.dueDate.day.toString().padLeft(2, '0')} "
                          "${task.dueDate.hour.toString().padLeft(2, '0')}:${task.dueDate.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                DropdownMenu<String>(
                  width: 180,
                  textStyle: TextStyle(color: Colors.black),
                  hintText: "Change Status",
                  initialSelection: null,
                  dropdownMenuEntries: [
                    ...statusOption.map((e) => DropdownMenuEntry(value: e, label: e))
                  ],
                  onSelected: (String? selected) {
                    if (selected != null) {
                      TaskStatus newStatus = TaskStatus.values.firstWhere((e) => e.name == selected);
                      task.status = newStatus;
                      taskController.tasks.refresh();
                      final userId = GetStorage().read("id");
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('tasks')
                          .doc(task.id)
                          .update({'status': newStatus.name});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم تغيير الحالة إلى: $selected')),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
