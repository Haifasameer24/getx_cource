import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/task_controller.dart';
import '../models/tsks_model.dart';

class DoneTask extends StatelessWidget {
  final box = GetStorage();
  final TaskController taskController = Get.find<TaskController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = box.read("id");
    final List<String> statusOptions =["inProgress"];

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Done Task',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: "RobotoSlab",
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('tasks')
                .where('status', isEqualTo: 'done')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                return Text("No done tasks yet.");

              final tasks = snapshot.data!.docs.map((doc) {
                return TaskModel.fromJson(doc.data() as Map<String, dynamic>);
              }).toList();

              return Column(
                children: tasks
                    .map((task) => _buildTaskCard(task, context, statusOptions, taskController)).toList()

              );
            },
          ),
        ],
      ),
    );
  }

}

//// widegt for list
Widget _buildTaskCard(
    TaskModel task,
    BuildContext context,
    List<String> statusOptions,
    TaskController taskController,
    ) {
  String currentStatusText = task.status.name;

  return Slidable(
      key: ValueKey(task.id),
  endActionPane: ActionPane(
  motion: ScrollMotion(),
  dismissible: DismissiblePane(
  onDismissed: () async{
  final userId=GetStorage().read("id");
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
  onPressed: (_){},
  backgroundColor: Colors.red,
  foregroundColor: Colors.white,
  icon: Icons.delete_outline,
  label: "Delete",
  ),
  ]),
    child: Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
        Colors.green,
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            task.description,
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            "Category : ${task.cat}",
            style: TextStyle(fontSize: 13, color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              DropdownMenu<String>(
                width: 180,
                textStyle: TextStyle(color: Colors.black),
                hintText: "Change Status",
                initialSelection: null,
                dropdownMenuEntries: [
                  ...statusOptions.map((e) => DropdownMenuEntry(value: e, label: e))
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
    ),);
}