import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presense_app/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoginView'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.emailC,
            decoration: InputDecoration(labelText: "EMAIL"),
          ),
          SizedBox(height: 20),
          Obx(
            () => TextField(
              obscureText: controller.isHide.value,
              controller: controller.passC,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.hidepass();
                  },
                  icon: controller.isHide.value == false
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Obx( //memantau 
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.value == false) {
                  //jika is loadig false maka bisa dijalankan
                  await controller.login(
                    controller.emailC.text,
                    controller.passC.text,
                  );
                }
              },
              child: controller.isLoading.value == false //jika is loading false maka ....
                  ? Text("Login")
                  : Text("Loafing"),
            ),
          ),

          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.RESET);
            },
            child: Text("Lupa passweord"),
          ),
        ],
      ),
    );
  }
}
