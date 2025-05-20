import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_course/screens/splash_screen.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController name = TextEditingController();
  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child:Column(
            children: [
              Text(("Hello ${box.read("name")}"),),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 50)
                  ),
                  onPressed: (){
                    Get.offAll(SplashScreen());
                  },
                  child: Text("Login", style: TextStyle(color: Colors.white),)
              ),
            ]
           
            
          )
        
        
      ),
    );
  }
}
