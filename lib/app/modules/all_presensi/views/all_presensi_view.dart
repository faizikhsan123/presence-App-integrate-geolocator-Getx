import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presense_app/app/routes/app_pages.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllPresensiView'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 161, 141, 164),
      ),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 15,
                top: 15,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: controller.AllpresenceStream(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var data = asyncSnapshot.data!.docs; //ambil yg di document

                if (data.isEmpty) {
                  //jika document kosong
                  return const Center(child: Text("History Absensi blm ada"));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: data.length,

                  itemBuilder: (context, index) {
                    var dataDoc = data[index].data(); //ambil nilai dari setiap document
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],

                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.DETAIL_PRESENSI,arguments: dataDoc); //kita ngelempar data juga
                          },

                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 20,
                            ),

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
                                      "${DateFormat.yMMMEd().format(DateTime.parse("${dataDoc?['date']}"))}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  "waktu ${DateFormat.jms().format(DateTime.parse("${dataDoc?['masuk']['date']}"))}",
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "keluar",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  //untuk keluar ada kondisi khusus karena blm tentu dia uda keluar tapi dia ingin liat absen nya
                                  dataDoc?['keluar'] == null
                                      ? "-"
                                      : "waktu ${DateFormat.jms().format(DateTime.parse("${dataDoc?['keluar']['date']}"))}",
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
