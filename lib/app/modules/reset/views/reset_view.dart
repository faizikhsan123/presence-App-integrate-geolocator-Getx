import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reset_controller.dart';

class ResetView extends GetView<ResetController> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('reset pass'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: controller.emailC,
                decoration: InputDecoration(hintText: "Masukkan Email"),
              ),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: () {
                controller.forgetPass(controller.emailC.text); //jalankan fungsi reset
                
              }, child: Text("reset password")),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
