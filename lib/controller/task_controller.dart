import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_course/models/tsks_model.dart';

import 'notifacation_controller.dart';

class TaskController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    streamTasks(); // تحميل المهام عند تشغيل الكنترولر
  }


  final taskNameController = TextEditingController();
  final taskTimeController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final statusTaskController = TextEditingController();
   final taskCatController = TextEditingController();

  final box = GetStorage();

  RxList<TaskModel> tasks = <TaskModel>[].obs;
  RxString searchText=' '.obs;


  void streamTasks() {
    final user = box.read("id");
    if (user == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("tasks")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((snapshot) {
      tasks.value = snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data()))
          .toList();
    },);
  }
  List<TaskModel> get filteredTasks {
    if (searchText.value.trim().isEmpty) return tasks;
    final query = searchText.value.toLowerCase();
    return tasks.where((task) {
      return task.name.toLowerCase().startsWith(query);
    }).toList();
  }

  Future addTask({required DateTime dueDate}) async {
    final user = box.read("id");

    if (user == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    final taskId = FirebaseFirestore.instance.collection('tasks').doc().id;

    final task = TaskModel(
      id: taskId,
      name: taskNameController.text.trim(),
      description: taskDescriptionController.text.trim(),
      userId: user,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      status: TaskStatus.upcoming,
      cat: taskCatController.text.trim(),
    );

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user)
          .collection('tasks')
          .doc(task.id)
          .set(task.toJson());
      Get.back();
      Get.snackbar("نجاح", "تم إضافة المهمة بنجاح ✅");

      taskNameController.clear();
      taskTimeController.clear();
      taskDescriptionController.clear();
    } catch (e) {
      Get.snackbar("فشل", e.toString());
    }
    update();
  }




}
