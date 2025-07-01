import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../controller/login_controller.dart';
import '../controller/them_controller.dart';

class SettingsPage extends StatelessWidget {
  final RxBool isNotificationOn = true.obs;
  final HomeController controller = Get.put(HomeController());
  final controllerLogout = Get.put(LoginController());
  final ThemeController themeController = Get.find();

  void _showEditDialog(BuildContext context) {
    controller.nameController.text = controller.userName.value;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/profail.jpeg'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
                onPressed: () async {
                  await controller
                      .updateUserName(controller.nameController.text);
                  Navigator.pop(context);
                },
                child: Text("Save")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        padding: EdgeInsets.only(top: kToolbarHeight + 24, left: 16, right: 16),
        children: [
          // Profile Card
          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/profail.jpeg'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _showEditDialog(context),
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2))
                              ],
                            ),
                            child: Icon(Icons.edit, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Obx(() => Text(
                    controller.userName.value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87),
                  )),
                  Text(
                    'haifa@example.com',
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 30),

          // Settings Section
          _buildSettingCard(
            theme,
            [
              Obx(() => SwitchListTile(
                title: Text('Notifications',
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87)),
                secondary: Icon(Icons.notifications_active,
                    color: Colors.blue),
                value: isNotificationOn.value,
                onChanged: (val) => isNotificationOn.value = val,
              )),
              SizedBox(
                height: 10,
              ),
              Obx(() => SwitchListTile(
                title: Text('Dark Mode',
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87)),
                secondary: Icon(Icons.dark_mode, color: Colors.blue),
                value: themeController.isDarkMode.value,
                onChanged: (val) => themeController.toggleTheme(val),
              )),
            ],
          ),

          SizedBox(height: 20),

          // Info Section
          _buildSettingCard(
            theme,
            [
              _buildTile(Icons.lock, 'Privacy', () {}, isDark),
              _buildTile(Icons.help_outline, 'Help & Support', () {}, isDark),
              _buildTile(Icons.call, 'Contact us', () {}, isDark),
              _buildTile(Icons.info_outline, 'About App', () {}, isDark),
              _buildTile(Icons.logout, 'Loge out', () {
                controllerLogout.logout();
              }, isDark),
            ],
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingCard(ThemeData theme, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap, bool isDark) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
      onTap: onTap,
    );
  }
}
