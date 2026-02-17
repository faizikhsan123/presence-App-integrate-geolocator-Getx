import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presense_app/app/controllers/page_index_controller.dart';
import 'package:presense_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

final pageC = Get.find<PageIndexController>(); //import controller

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.toNamed(Routes.PROFILE);
          },
          icon: Icon(Icons.person),
        ),
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.roleStream(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              } else if (asyncSnapshot.connectionState ==
                  ConnectionState.active) {
                String role = asyncSnapshot.data!.data()!['role'];
                if (role == "admin") {
                  return IconButton(
                    icon: const Icon(Icons.person_add_alt_sharp),
                    onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
                  );
                } else {
                  SizedBox();
                }
              }

              return SizedBox();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('HomeView is working', style: TextStyle(fontSize: 20)),
      ),
     bottomNavigationBar: Obx(
        () => ConvexAppBar(
          //widget bottom navbar
          style: TabStyle.fixed, //style bottom navbar
          initialActiveIndex: pageC.currentIndex.value, //index active
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.person, title: 'Pofile'),
          ],
          onTap: (index) {
            //function ketika di klik sesuai index
            pageC.changePage(index);
          },
        ),
      ),
    );
  }
}
