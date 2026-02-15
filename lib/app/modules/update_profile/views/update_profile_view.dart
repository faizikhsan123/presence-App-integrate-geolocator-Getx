import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  var tangkapArgumen = Get.arguments; //ambil data dari halaman sebelumnya(argument)

  @override
  Widget build(BuildContext context) {
    controller.nipC.text = tangkapArgumen['nip'];
    controller.namaC.text = tangkapArgumen['nama'];
    controller.emailC.text = tangkapArgumen['email'];
    return Scaffold(
      appBar: AppBar(title: const Text('UpdateProfileView'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            readOnly: true,
            controller: controller.nipC,
            decoration: InputDecoration(labelText: "NIP"),
          ),
          SizedBox(height: 20),
          TextField( //hanya nama yang bisa diupdate
            controller: controller.namaC,
            decoration: InputDecoration(labelText: "NAMA"),
          ),
          SizedBox(height: 20),
          TextField(
            readOnly: true, 
            controller: controller.emailC,
            decoration: InputDecoration(labelText: "EMAIL"),
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.value == false) {
                  //hanya jalankan ketika isLoading false
                  await controller.updateProfile(
                    controller.emailC.text,
                    controller.nipC.text,
                    controller.namaC.text,
                  );
                }
              },
              child: controller.isLoading.value == false
                  ? Text("Uodate Profile")
                  : Text("Loading..."),
            ),
          ),
        ],
      ),
    );
  }
}
