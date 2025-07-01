import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_list/horizontal_list.dart';

import '../controller/addCatgory_controller.dart';
import '../screens/CategoryDetailPage.dart';

class ListTask extends StatelessWidget {
  final CategoryController addCatogory = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    if (addCatogory.categories.isEmpty) {
      addCatogory.fetchCategories();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            'Categories',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: "RobotoSlab",
            ),
          ),
        ),
        SizedBox(height: 10),

        // Horizontal List (with Obx)
        Obx(() {
          return HorizontalListView(
            width: double.infinity,
            height: 100,
            list: [
              ...addCatogory.filteredCategories
                  .map((c) => taskCard(context, c.name, c.color))
                  .toList(),
              addCard(context),
            ],
            durationAnimation: Duration(milliseconds: 300),
            enableManualScroll: true,
          );
        }),
      ],
    );
  }

  Widget taskCard(BuildContext context, String title, Color color) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CategoryDetailPage(catName: title));
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget addCard(BuildContext context) {
    Color? selectedColor;
    final addCatogory = Get.find<CategoryController>();

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 24,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: addCatogory.CatnameController,
                        decoration: InputDecoration(
                          labelText: 'Category Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: addCatogory.CatdescController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Category Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Color',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                          Colors.orange,
                          Colors.purple,
                          Colors.teal
                        ].map((color) {
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedColor = color;
                                addCatogory.selectedColor = color;
                              });
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await addCatogory.addCategory(context);
                        },
                        child: Text('Done'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Theme.of(context).iconTheme.color, size: 30),
              SizedBox(height: 8),
              Text(
                'Add Category',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
