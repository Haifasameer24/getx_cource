import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/category.dart';

class CategoryController extends GetxController {
  final CatnameController = TextEditingController();
  final CatdescController = TextEditingController();
  Color? selectedColor;

  final categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
  void fetchCategories() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshot) {
      categories.value = snapshot.docs.map((doc) {
        return Category(
          id: doc.id,
          name: doc['name'],
          description: doc['description'],
          color: Color(doc['color']),
        );
      }).toList();
    });
  }

  void clear() {
    CatnameController.clear();
    CatdescController.clear();
    selectedColor = null;
  }
  Future<void> addCategory(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar("User not logged in", "يرجى تسجيل الدخول أولاً");
      return;
    }

    final name = CatnameController.text.trim();
    final desc = CatdescController.text.trim();

    if (name.isEmpty || desc.isEmpty) {
      Get.snackbar("خطأ", "يرجى تعبئة كل الحقول");
      return;
    }

    if (selectedColor == null) {
      Get.snackbar("خطأ", "يرجى اختيار لون");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('categories')
          .add({
        'name': name,
        'description': desc,
        'color': selectedColor!.value,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });

      clear();
      Navigator.pop(context);
      Get.snackbar("تمت الإضافة", "تمت إضافة الصنف بنجاح");
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    }
  }

  RxString searchText = ''.obs;

  List<Category> get filteredCategories {
    if (searchText.value.trim().isEmpty) return categories;
    return categories.where((cat) {
      return cat.name.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();
  }


  @override
  void onClose() {
    CatnameController.dispose();
    CatdescController.dispose();
    super.onClose();
  }
}
