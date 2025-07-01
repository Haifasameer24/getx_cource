import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _loadThemeFromStorage();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  bool _loadThemeFromStorage() => _storage.read(_key) ?? false;

  void saveThemeToStorage(bool isDarkMode) => _storage.write(_key, isDarkMode);

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    saveThemeToStorage(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
