import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_course/controller/signup_controllr.dart';
import 'package:lottie/lottie.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obsecurePassword = true;
  bool _obsecureConfirmPassword = true;
  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.08,
            horizontal: screenWidth * 0.08,
          ),
          child: Column(
            children: [
              Lottie.asset("assets/lottie/splash.json", width: screenWidth * 0.4),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                controller: controller.nameController,
                icon: Icons.person,
                hint: "Enter your name",
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                controller: controller.emailController,
                icon: Icons.email,
                hint: "Enter E-mail",
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                controller: controller.passwordController,
                icon: _obsecurePassword ? Icons.visibility_off : Icons.visibility,
                hint: "Enter your password",
                obscure: _obsecurePassword,
                toggleObscure: () {
                  setState(() => _obsecurePassword = !_obsecurePassword);
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                controller: controller.passwordConfirmController,
                icon: _obsecureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                hint: "Confirm password",
                obscure: _obsecureConfirmPassword,
                toggleObscure: () {
                  setState(() => _obsecureConfirmPassword = !_obsecureConfirmPassword);
                },
              ),
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                  ),
                  onPressed: () => controller.register(),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "You have an account?",
                  style: TextStyle(color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
    VoidCallback? toggleObscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: toggleObscure == null
            ? Icon(icon)
            : GestureDetector(
          onTap: toggleObscure,
          child: Icon(icon),
        ),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
