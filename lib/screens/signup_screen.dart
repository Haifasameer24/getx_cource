import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_course/controller/signup_controllr.dart';
import 'package:lottie/lottie.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obsecurePassword = true ;
  bool _obsecureConfirmPassword = true ;
  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 35),

        child:Center(
          child: Column(
            children: [
              Lottie.asset("assets/lottie/splash.json", width: 90),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 20,left: 20),
                child: TextField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                      prefix: Icon(EvaIcons.personOutline),
                      hintText: "Enter Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 20,left: 20),
                child: TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                      prefix: Icon(Icons.email),
                      hintText: "Enter E-mail",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 20,left: 20),
                child: TextField(
                  controller: controller.passwordController,
                  obscureText: _obsecurePassword,
                  decoration: InputDecoration(
                      prefix: Icon(Icons.password),
                      suffix: GestureDetector(
                          onTap: () => setState(()=> _obsecurePassword = !_obsecurePassword),
                          child: Icon(
                              _obsecurePassword ?
                              Icons.remove_red_eye : Icons.remove_red_eye_outlined
                          )),
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 20,left: 20),
                child: TextField(
                  controller: controller.passwordConfirmController,
                  obscureText: _obsecureConfirmPassword,
                  decoration: InputDecoration(
                      prefix: Icon(Icons.password),
                      suffix: GestureDetector(
                          onTap: () => setState(()=> _obsecureConfirmPassword = !_obsecureConfirmPassword),
                          child: Icon(
                              _obsecureConfirmPassword ?
                              Icons.remove_red_eye : Icons.remove_red_eye_outlined
                          )),
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 50)
                  ),
                  onPressed: (){
                    controller.register();
                  },
                  child: Text("Sign up", style: TextStyle(color: Colors.white),)
              ),
              Spacer(),
              TextButton(
                onPressed: (){
                  Get.back();
                },
                child: Text("You have an account?", style: TextStyle(color: Colors.blue.shade700),),
              )


            ],
          ),
        ) ,
      ),
    );
  }
}
