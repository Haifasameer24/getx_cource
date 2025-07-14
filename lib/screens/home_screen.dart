import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controller/addCatgory_controller.dart';
import '../controller/home_controller.dart';
import '../controller/login_controller.dart';
import '../controller/task_controller.dart';
import '../models/tsks_model.dart';
import '../screens/setting_screen.dart';
import '../wedgit/DoneTask.dart';
import '../wedgit/add_button.dart';
import '../wedgit/inProgress.dart';
import '../wedgit/upcoming.dart';
import '../wedgit/header.dart';
import '../wedgit/categoties.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final taskController = Get.put(TaskController());
  final categoryController = Get.put(CategoryController());
  final GetStorage box = GetStorage();

  int _selectedIndex = 0;
  String filterMode = "Tasks"; // default

  @override
  void initState() {
    super.initState();
  }

  List<Widget> getPages() {
    return [
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, John!",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Have a nice day!",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/profail.jpeg',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Search + Filter
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      if (filterMode == "Tasks") {
                        taskController.searchText.value = value;
                      } else if (filterMode == "Categories") {
                        categoryController.searchText.value = value;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: filterMode == "Tasks" ? 'Search tasks...' : 'Search categories...',
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Categories section
            ListCatigroies(),
            SizedBox(height: 20),

            // Tasks sections
            UpComingTasks(),
            InProgress(),
            DoneTask(),
          ],
        ),
      ),
      SettingsPage(),
    ];
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text('Filter', style: Theme.of(context).textTheme.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Tasks'),
                onTap: () {
                  setState(() {
                    filterMode = "Tasks";
                  });
                  Get.back();
                },
              ),
              ListTile(
                title: Text('Categories'),
                onTap: () {
                  setState(() {
                    filterMode = "Categories";
                  });
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: getPages()[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(context, icon: Icons.home_rounded, index: 0),
            _buildAddButton(context, primaryColor),
            _buildTabItem(context, icon: Icons.settings_rounded, index: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, Color primaryColor) {
    return GestureDetector(
      onTap: () {
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
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, {required IconData icon, required int index}) {
    final isSelected = _selectedIndex == index;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Icon(
        icon,
        size: 24,
        color: isSelected ? primaryColor : Theme.of(context).iconTheme.color?.withOpacity(0.6),
      ),
    );
  }
}
