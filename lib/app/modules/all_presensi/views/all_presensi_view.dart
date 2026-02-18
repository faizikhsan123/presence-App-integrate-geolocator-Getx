import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presense_app/app/routes/app_pages.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AllPresensiView'), centerTitle: true),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10 ,bottom: 15,top: 15),
              child: TextField(
                // controller: controller.searchC,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),)
                  ),
              
                
              ),
            ),
          ),
        
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
            
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.DETAIL_PRESENSI);
                      },
            
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
            
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Masuk",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${DateFormat.yMMMEd().format(DateTime.now())}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
            
                            Text("waktu ${DateFormat.jms().format(DateTime.now())}"),
                            SizedBox(height: 10),
                            Text(
                              "keluar",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("waktu ${DateFormat.jms().format(DateTime.now())}"),
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
            ),
          ),
        ],
      ),
    );
  }
}
