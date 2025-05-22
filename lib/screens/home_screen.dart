import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_course/controller/login_controller.dart';
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
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("User ID ${box.read("id")}"),
              Text("User Name ${box.read("name")}"),
              Text("User Email ${box.read("email")}"),
              Text("User Create Date ${box.read("create_date")}"),
              Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20 , horizontal: 50)
                  ),
                  onPressed: (){
                    controller.logout();
                  },
                  child: Text("Logout", style: TextStyle(color: Colors.white),)
              ),
            ]
           
            
          )
        
        
      ),
    );
  }
}
