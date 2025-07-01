import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controller/addCatgory_controller.dart';
import '../controller/home_controller.dart';
import '../controller/login_controller.dart';
import '../controller/task_controller.dart';
import '../models/Notification.dart';
import '../models/tsks_model.dart';
import '../screens/setting_screen.dart';
import '../wedgit/DoneTask.dart';
import '../wedgit/Notification.dart';
import '../wedgit/add_button.dart';
import '../wedgit/categoties.dart';
import '../wedgit/header.dart';
import '../wedgit/inProgress.dart';
import '../wedgit/upcoming.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final taskController = Get.put(TaskController());
  final controller = Get.put(LoginController());
  final controller2 = Get.put(HomeController());
  final GetStorage box = GetStorage();

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    Get.put(CategoryController());
  }

  List<Widget> getPages() {
    return [
      Obx(() {
        final isSearching = taskController.searchText.value.trim().isNotEmpty;
        return SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(),
              SizedBox(height: 20),
              if (!isSearching ||
                  taskController.filteredTasks
                      .any((task) => task.status == TaskStatus.upcoming)) ...[
                ListTask(),
                SizedBox(height: 20),
              ],
              if (!isSearching ||
                  taskController.filteredTasks
                      .any((task) => task.status == TaskStatus.upcoming)) ...[
                MyTask(),
                SizedBox(height: 20),
              ],
              if (!isSearching ||
                  taskController.filteredTasks
                      .any((task) => task.status == TaskStatus.inProgress)) ...[
                InProgress(),
                SizedBox(height: 20),
              ],
              if (!isSearching ||
                  taskController.filteredTasks
                      .any((task) => task.status == TaskStatus.done)) ...[
                DoneTask(),
                SizedBox(height: 20),
              ],
            ],
          ),
        );
      }),
      SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 8.0),
          child: getPages()[_selectedIndex],
        ),
      ),

      floatingActionButton: SizedBox(
        height: 50,
        width: 45,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => AddButton(),
            );
          },
          child: Icon(Icons.add, size: 25),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4,
        child: Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (_selectedIndex != 0) {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  } else {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => AddButton(),
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      size: 20,
                      color: _selectedIndex == 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 10, // ← تقليل حجم النص
                        color: _selectedIndex == 0
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(width: 40),

              InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings,
                      size: 20,
                      color: _selectedIndex == 1
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 10,
                        color: _selectedIndex == 1
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );

  }
}
