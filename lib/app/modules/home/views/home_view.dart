import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presense_app/app/controllers/page_index_controller.dart';
import 'package:presense_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

final pageC = Get.find<PageIndexController>();

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
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
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.roleStream(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var data = asyncSnapshot.data!.data();
          String imageUrl =
              "https://ui-avatars.com/api/?name=${data!['nama']}&background=random&size=256";

          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 75,
                      height: 75,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage: data['photo'] == null
                              ? NetworkImage(imageUrl)
                              : NetworkImage(data['photo']),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 200,
                        child: Text(
                          "${data['alamat'] == null ? "" : data['alamat']}",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "${data['job']}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "${data['nip']}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Text("${data['nama']}", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.TodayStream(),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    var data = asyncSnapshot.data?.data();

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("Masuk"),
                            Text(
                              data?['masuk'] == null
                                  ? "-"
                                  : DateFormat.jms().format(
                                      DateTime.parse(data!['masuk']['date']),
                                    ),
                            ),
                          ],
                        ),
                        Container(
                          width: 2,
                          height: 40,
                          color: const Color.fromARGB(255, 133, 126, 103),
                        ),
                        Column(
                          children: [
                            Text("Keluar"),
                            Text(
                              data?['keluar'] == null
                                  ? "-"
                                  : DateFormat.jms().format(
                                      DateTime.parse(data!['keluar']['date']),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Divider(thickness: 2, color: Colors.amber),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last 5 Days",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.ALL_PRESENSI);
                    },
                    child: Text("see more"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.presenceStream(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (asyncSnapshot.connectionState == ConnectionState.active) {
                    var data = asyncSnapshot.data!.docs;

                    if (data.isEmpty) {
                      return Center(child: Text("Belum ada presensi"));
                    } //jika ada data
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      reverse: true, //
                      itemBuilder: (context, index) {
                        var dataPresence = data[index].data();

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200],

                            child: InkWell(
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_PRESENSI,arguments: dataPresence); //kirim data ke detail
                              },

                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.all(20),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Masuk",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          dataPresence['date'] == null
                                              ? "-"
                                              : DateFormat.yMMMEd().format(
                                                  DateTime.parse(
                                                    dataPresence['date'],
                                                  ),
                                                ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      dataPresence['masuk'] == null
                                          ? "-"
                                          : DateFormat.jms().format(
                                              DateTime.parse(
                                                dataPresence['masuk']['date'],
                                              ),
                                            ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 10),
                                    Text(
                                      "keluar",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      dataPresence['keluar'] == null
                                          ? "-"
                                          : DateFormat.jms().format(
                                              DateTime.parse(
                                                dataPresence['keluar']['date'],
                                              ),
                                            ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Obx(
        () => ConvexAppBar(
          style: TabStyle.fixed,
          initialActiveIndex: pageC.currentIndex.value,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.person, title: 'Pofile'),
          ],
          onTap: (index) {
            pageC.changePage(index);
          },
        ),
      ),
    );
  }
}
