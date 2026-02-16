import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presense_app/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.profileStream(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.connectionState == ConnectionState.active) {
            var data = asyncSnapshot.data!.data(); //data snapshot
            print(data);

            if (data == null) {
              return const Center(child: Text("Data profile tidak ditemukan"));
            }

            String imageUrl =
                "https://ui-avatars.com/api/?name=${data['nama']}&background=random&size=256";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: data['photo'] == null //kalo dia null tampilkan defaulat gambar
                        ? NetworkImage(imageUrl)
                        : NetworkImage(data['photo']),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    data['nama'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.badge),
                          title: const Text("NIP"),
                          subtitle: Text(data['nip']),
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text("Email"),
                          subtitle: Text(data['email']),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //ke halaman update dan kirim data dari streamnya profile (snapshot)
                        Get.toNamed(Routes.UPDATE_PROFILE, arguments: data);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Update Profile"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(Routes.RESET);
                      },
                      icon: const Icon(Icons.lock),
                      label: const Text("Update password"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.logout();
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          111,
                          102,
                          102,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
