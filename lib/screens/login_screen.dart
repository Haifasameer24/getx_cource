import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getx_course/controller/login_controller.dart';
import 'package:getx_course/screens/home_screen.dart';
import 'package:getx_course/screens/signup_screen.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());

  bool _obsecurePassword = true ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 35),
        child: Center(
          child: Column(
            children: [
              Lottie.asset("assets/lottie/splash.json", width: 90),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 20,left: 20),
                child: TextField(
                  controller: loginController.emailController,
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
                  controller: loginController.passwordController,
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 50)
                ),
                  onPressed: (){
                  loginController.login();
                  },
                  child: Text("Login", style: TextStyle(color: Colors.white),)
              ),
              Spacer(),
              TextButton(
                  onPressed: (){
                    Get.to(SignupScreen());
                  },
                  child: Text("Don't have an account ? SignUp", style: TextStyle(color: Colors.blue.shade700),),
              )

            ],
          ),
        ),
      )

    );
  }
}
