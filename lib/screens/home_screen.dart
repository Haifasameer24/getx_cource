import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/home_controller.dart';
import '../controller/login_controller.dart';
import '../wedgit/header.dart';

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
        appBar: AppBar
          (
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.yellow),
          actions:
          [
            Container(
                margin: EdgeInsets.only(right: 10),
                child:IconButton
                  (
                  icon:Icon(Icons.notifications_on_outlined,color: Colors.grey),
                  onPressed: (){},
                )
            )

          ],
        ),
        body: Container(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               HomeScreen()
              ],
            )
        )
    );
  }
}

