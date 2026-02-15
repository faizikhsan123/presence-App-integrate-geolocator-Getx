import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presense_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        leading: IconButton(onPressed: (){ //ini untuk profile
          Get.toNamed(Routes.PROFILE); //pindah ke profile
        }, icon: Icon(Icons.person)),
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            //dibungkus stream builder (data realtime)
            stream: controller.roleStream(), //stream controllernya
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              } else if (asyncSnapshot.connectionState == ConnectionState.active) {   
                String role = asyncSnapshot.data!.data()!['role']; //ambil role nya saja  dari firestore
                if (role == "admin") { //ini jika role admin
                  return IconButton(
                    icon: const Icon(Icons.person_add_alt_sharp),
                    onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
                  );
                }else { //ini jika role pegawai
                  SizedBox();
                }
              }
              //ini default kosong
              return SizedBox();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('HomeView is working', style: TextStyle(fontSize: 20)),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () {
            if (controller.isLoading.value == false) {
              controller.logout();
            }
          },
          child: controller.isLoading.value == false
              ? Icon(Icons.logout)
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
