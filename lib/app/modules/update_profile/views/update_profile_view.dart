import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  var tangkapArgumen = Get.arguments;

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
          TextField(
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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetBuilder<UpdateProfileController>(
                    builder: (controller) => controller.pickedImage != null
                        ? Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: Image.file(
                                          File(controller.pickedImage!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            controller.deleteImage();
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        color: const Color.fromARGB(
                                          115,
                                          212,
                                          199,
                                          199,
                                        ),
                                        height: 30,
                                        child: TextButton(
                                          onPressed: () {
                                            controller.uploadImage();
                                          },
                                          child: Obx(
                                            () => FittedBox(
                                              child:
                                                  controller
                                                          .uploadButton
                                                          .value ==
                                                      false
                                                  ? Text(
                                                      "upload Image",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      "Loading...",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Text("No Image Selected"),
                  ),

                  TextButton(
                    onPressed: () {
                      controller.selectImage();
                    },
                    child: Text("Pilih File"),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.value == false) {
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
