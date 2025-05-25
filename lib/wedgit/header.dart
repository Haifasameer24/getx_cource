import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HeaderWiget extends StatelessWidget{
    final GetStorage box = GetStorage();
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
        padding:  EdgeInsets.only(top: 30, left: 30, right: 30),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello ${box.read("name")}',style: TextStyle(color: Colors.black,fontSize: 20),)
          ],
        )
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
           // controller: loginController.emailController,
            decoration: InputDecoration(
                prefix: Icon(Icons.search),
                hintText: "Search your Task",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.grey.shade200
            ),
          ),
        ),
      ],
    );
  }
}