import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/addCatgory_controller.dart';
import '../controller/task_controller.dart';

enum SearchFilter { tasks, categories }

class HeaderWidget extends StatefulWidget {
  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final TaskController taskController = Get.find<TaskController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  final Rx<SearchFilter> searchFilter = SearchFilter.tasks.obs;

  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Filter by",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(),
            RadioListTile<SearchFilter>(
              title: const Text('Tasks'),
              value: SearchFilter.tasks,
              groupValue: searchFilter.value,
              onChanged: (SearchFilter? selected) {
                if (selected != null) {
                  searchFilter.value = selected;
                  taskController.searchText.value = '';
                  categoryController.searchText.value = '';
                }
              },
            ),
            RadioListTile<SearchFilter>(
              title: const Text('Categories'),
              value: SearchFilter.categories,
              groupValue: searchFilter.value,
              onChanged: (SearchFilter? selected) {
                if (selected != null) {
                  searchFilter.value = selected;
                  taskController.searchText.value = '';
                  categoryController.searchText.value = '';
                }
              },
            ),
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => TextField(
              onChanged: (value) {
                if (searchFilter.value == SearchFilter.tasks) {
                  taskController.searchText.value = value;
                  categoryController.searchText.value = '';
                } else {
                  categoryController.searchText.value = value;
                  taskController.searchText.value = '';
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                hintText: searchFilter.value == SearchFilter.tasks
                    ? "Search Tasks"
                    : "Search Categories",
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
                    Theme.of(context).cardColor.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            )),
          ),

          const SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: Theme.of(context).iconTheme.color),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
    );
  }
}
