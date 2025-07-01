import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/addCatgory_controller.dart';
import '../controller/task_controller.dart';
import '../models/tsks_model.dart';

class AddButton extends StatelessWidget {
  final taskController = Get.find<TaskController>();
  final categoryController = Get.find<CategoryController>();

  AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDateTime;
    String? selectedCategory;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(  // لمنع overflow عند ظهور الكيبورد
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // حقل اسم المهمة
                TextField(
                  controller: taskController.taskNameController,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),

                // حقل الوصف
                TextField(
                  controller: taskController.taskDescriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),

                // اختيار التاريخ والوقت
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        final combined = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        setModalState(() {
                          selectedDateTime = combined;
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: double.infinity,
                    child: Text(
                      selectedDateTime != null
                          ? 'Due: ${selectedDateTime.toString()}'
                          : 'Select Due Date & Time',
                      style: TextStyle(
                        color: selectedDateTime != null ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Obx(() {
                  if (categoryController.categories.isEmpty) {
                    return const Center(
                      child: Text('Loading categories...'),
                    );
                  }
                  return SizedBox(
                    width: 500,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        border: OutlineInputBorder(),
                      ),
                      value: categoryController.categories.any((cat) => cat.name == selectedCategory)
                          ? selectedCategory
                          : null,
                      items: categoryController.categories
                          .map((cat) => DropdownMenuItem(
                        value: cat.name,
                        child: Text(cat.name),
                      ))
                          .toList(),
                      onChanged: (selected) {
                        setModalState(() {
                          selectedCategory = selected;
                          taskController.taskCatController.text = selected!;
                        });
                      },
                      menuMaxHeight: 200,
                    ),
                  );
                }),

                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () async {
                    final name = taskController.taskNameController.text.trim();
                    final desc = taskController.taskDescriptionController.text.trim();

                    if (name.isEmpty || desc.isEmpty) {
                      Get.snackbar("Missing Fields", "Please enter task name and description.");
                      return;
                    }

                    if (selectedCategory == null) {
                      Get.snackbar("Missing Category", "Please select a category.");
                      return;
                    }

                    if (selectedDateTime == null) {
                      Get.snackbar("Missing Date", "Please select due date & time.");
                      return;
                    }

                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      Get.snackbar("Error", "User not logged in");
                      return;
                    }

                    final userId = user.uid;
                    final docRef = FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .collection("tasks")
                        .doc();

                    final newTask = TaskModel(
                      id: docRef.id,
                      name: name,
                      description: desc,
                      userId: userId,
                      createdAt: DateTime.now(),
                      dueDate: selectedDateTime!,
                      status: TaskStatus.upcoming,
                      cat: selectedCategory!,
                    );

                    try {
                      await docRef.set(newTask.toJson());

                      taskController.tasks.add(newTask);
                      Navigator.pop(context);
                      Get.snackbar("Task Added", "تمت إضافة المهمة بنجاح");
                    } catch (e) {
                      Get.snackbar("Error", e.toString());
                    }
                  },
                  child: const Text('Done'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 150),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
