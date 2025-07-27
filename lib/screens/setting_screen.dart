import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../controller/login_controller.dart';
import '../controller/profile_image_controller.dart';
import '../controller/task_controller.dart';
import '../controller/them_controller.dart';

class SettingsPage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final LoginController loginController = Get.put(LoginController());
  final ProfileImageController profileImageController = Get.put(ProfileImageController());
  final ThemeController themeController = Get.find<ThemeController>();

  SettingsPage({Key? key}) : super(key: key);

  void _showEditDialog(BuildContext context) {
    homeController.nameController.text = homeController.userName.value;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              final imageUrl = profileImageController.photoUrl.value;
              return Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : const AssetImage('assets/images/profail.jpeg') as ImageProvider,
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      await profileImageController.pickAndUploadImage();
                    },
                    child: Text(
                      'Change Profile Picture',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 12),
            TextField(
              controller: homeController.nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                filled: true,
                fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await homeController.updateUserName(homeController.nameController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }


  Widget _buildSettingCard(BuildContext context, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, VoidCallback onTap, bool isDark) {
    return ListTile(
      leading: Icon(icon,  color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Theme.of(context).colorScheme.primary),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final taskcontroller = Get.put(TaskController());
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        padding: EdgeInsets.only(top: kToolbarHeight + 24, left: 16, right: 16),
        children: [
          // Profile Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(() {
                        final imageUrl = profileImageController.photoUrl.value;
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/images/profail.jpeg') as ImageProvider,
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCircleButton(context, Icons.edit, () => _showEditDialog(context)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Obx(() => Text(
                    homeController.userName.value,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
                  )),
                  Text(
                    'haifa@example.com',
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Settings Section
          _buildSettingCard(context, [
            Obx(() => SwitchListTile(
              title: Text('Notifications', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              secondary: Icon(Icons.notifications_active, color: theme.colorScheme.primary),
              value: taskcontroller.isNotificationOn.value,
              onChanged: (val) => taskcontroller.isNotificationOn.value = val,
            )),
            const SizedBox(height: 10),
            Obx(() => SwitchListTile(
              title: Text('Dark Mode', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              secondary: Icon(Icons.dark_mode, color: theme.colorScheme.primary),
              value: themeController.isDarkMode.value,
              onChanged: (val) => themeController.toggleTheme(val),
            )),
          ]),

          const SizedBox(height: 20),

          // Info Section
          _buildSettingCard(context, [
            _buildTile(context, Icons.lock, 'Privacy', () {}, isDark),
            _buildTile(context, Icons.help_outline, 'Help & Support', () {}, isDark),
            _buildTile(context, Icons.call, 'Contact us', () {}, isDark),
            _buildTile(context, Icons.info_outline, 'About App', () {}, isDark),
            _buildTile(context, Icons.logout, 'Log out', () {
              loginController.logout();
            }, isDark),
          ]),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

Widget _buildCircleButton(BuildContext context, IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Icon(icon, size: 18, color: Colors.white),
    ),
  );
}

