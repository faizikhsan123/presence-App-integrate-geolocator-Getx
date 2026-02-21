import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presense_app/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
      body: GetBuilder<AllPresensiController>( //bungkus dengan getbuilder karena datatnya tidak bisa di rx dan pastekan controllernya
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  //gatni ke future builder
                  future: controller.AllpresenceFuture(), //gatni stream
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var data = asyncSnapshot.data!.docs;

                    if (data.isEmpty) {
                      return const Center(
                        child: Text("History Absensi blm ada"),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: data.length,

                      itemBuilder: (context, index) {
                        var dataDoc = data[index].data();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200],

                            child: InkWell(
                              onTap: () {
                                Get.toNamed(
                                  Routes.DETAIL_PRESENSI,
                                  arguments: dataDoc,
                                );
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.dialog(
            Dialog(
              //widget dialog
              child: Container(
                height: 400,
                padding: EdgeInsets.all(20),
                child: SfDateRangePicker(
                  //widget datepicker
                  selectionMode:DateRangePickerSelectionMode.range, //mode datepicker
                  todayHighlightColor: Colors.blue,
                  showActionButtons: true, //tampilkan tombol
                  onCancel: () => Get.back(), //ketika tombol cancel ditekan
                  onSubmit: (obj) {  //ketika tombol ok ditekan
                  print(obj);
                   
                    if (obj != null) {    //memastikakn user pilih range tanggal
                      if ((obj as PickerDateRange).endDate != null) {
                        //memastikan user pilih range tanggal  akhir
                        controller.pickDate(obj.startDate!, obj.endDate!); //jalankan fungsi pickdate yang diamana ada tanggal awal dan akhir dari range
                      }
                    }
                  },
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.calendar_month),
      ),
    );
  }
}
