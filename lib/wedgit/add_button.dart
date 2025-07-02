import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_course/services/notification_service.dart';
import '../controller/addCatgory_controller.dart';
import '../controller/task_controller.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});
  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  final taskController = Get.find<TaskController>();
  DateTime? selectedDateTime;
  int? hour;
  int? day;
  int? month;
  int? year;
  int? minute;
  String? notiTitle;
  String? notiDesc;

  final categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskController.taskNameController,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: taskController.taskDescriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final pickedDateTime = await pickDateTime(context, initialDate: selectedDateTime ?? DateTime.now());
                    if (pickedDateTime != null) {
                      setModalState(() {
                        selectedDateTime = pickedDateTime;
                        taskController.taskTimeController.text = pickedDateTime.toString();
                        taskController.realDueDate = pickedDateTime;
                        hour = pickedDateTime.hour;
                        minute = pickedDateTime.minute;
                        month = pickedDateTime.month;
                        day = pickedDateTime.day;
                        year = pickedDateTime.year;
                      });
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
                      taskController.taskTimeController.text.isNotEmpty
                          ? 'Due: ${taskController.taskTimeController.text}'
                          : 'Select Due Date & Time',
                      style: TextStyle(
                        color: taskController.taskTimeController.text.isNotEmpty ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Obx(() {
                  if (categoryController.categories.isEmpty) {
                    return const Center(child: Text('Loading categories...'));
                  }
                  return SizedBox(
                    width: 500,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        border: OutlineInputBorder(),
                      ),
                      value: taskController.taskCatController.text.isNotEmpty
                          ? taskController.taskCatController.text
                          : null,
                      items: categoryController.categories
                          .map((cat) => DropdownMenuItem(
                        value: cat.name,
                        child: Text(cat.name),
                      ))
                          .toList(),
                      onChanged: (selected) {
                        setModalState(() {
                          taskController.taskCatController.text = selected!;
                        });
                      },
                      menuMaxHeight: 200,
                    ),
                  );
                }),
                SizedBox(height: 16),

                // زر Done
                ElevatedButton(
                  onPressed: () async {
                    if (kDebugMode) {
                      print("Selected DateTime: ${taskController.taskTimeController.text}");
                    }
                    if (kDebugMode) {
                      print("Selected Category: ${taskController.taskCatController.text}");
                    }
                    notiTitle = taskController.taskNameController.text;
                    notiDesc = taskController.taskDescriptionController.text;
                    if (taskController.taskTimeController.text.isEmpty) {
                      Get.snackbar("Error", "Please add Date & Time");
                      return;
                    }
                    if (taskController.taskNameController.text.trim().isEmpty) {
                      Get.snackbar("Error", "Please add task name");
                      return;
                    }
                    if (taskController.taskCatController.text.isEmpty) {
                      Get.snackbar("Error", "Please select category");
                      return;
                    }

                    if (taskController.realDueDate == null) {
                      Get.snackbar("Error", "Please add Date & Time");
                      return;
                    }
                    await taskController.addTask(dueDate: taskController.realDueDate!);
                    await NotificationService.scheduleNotification(
                      title:  notiTitle.toString(),
                      body: notiDesc.toString(),
                      day: day!,
                      month: month!,
                      year: year!,
                      hour: hour!,
                      minute:minute!,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 150),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<DateTime?> pickDateTime(BuildContext context, {DateTime? initialDate}) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return null;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return null;

    final finalDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (kDebugMode) {
      print("Picked DateTime: $finalDateTime");
    }
    return finalDateTime;
  }
}
