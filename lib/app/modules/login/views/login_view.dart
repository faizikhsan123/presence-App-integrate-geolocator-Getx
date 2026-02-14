import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.emailC,
            decoration: InputDecoration(labelText: "EMAIL"),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.passC,
            decoration: InputDecoration(labelText: "Password"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text("Login"),
            onPressed: () => controller.login( //jalnkan fungsi
              controller.emailC.text,
              controller.passC.text,
            ),
          ),
        ],
      )
    );
  }
}
