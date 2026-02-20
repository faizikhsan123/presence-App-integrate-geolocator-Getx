import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  var data = Get .arguments; //ambil data dari halaman sebelumnya yg dilempar dari argument

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailPresensiView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "${DateFormat.yMMMEd().format(DateTime.parse("${data['date']}"))}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //ambil data datanya yg diambil dari argument
                  Text("Masuk", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "Jam : ${DateFormat.jms().format(DateTime.parse("${data?['masuk']['date']}"))} ",
                  ),
                  Text(
                    "Posisi : ${data?['masuk']['latitude']}, ${data?['masuk']['longitude']} ",
                  ),
                  Text("Status :${data?['masuk']['status']} "),
                  Text("jarak :${data?['masuk']['jarak']} meter "),
                  Text("alamat :${data?['masuk']['alamat']} "),
                  SizedBox(height: 20),

                  //khusus untuk keluar dia bisa aja uda absen tapi blm absen keluar jadi kita cek
                  Text("keluar", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "Jam : ${data?['keluar'] == null ? "-" : DateFormat.jms().format(DateTime.parse("${data?['keluar']['date']}"))} ",
                  ),
                 Text(
                    "Posisi : ${data?['keluar'] == null ? "-" : data?['keluar']['latitude'] }, ${data?['keluar'] == null ? "-" : data?['keluar']['longitude']} ",
                  ),
                  Text("Status : ${data?['keluar'] == null ? "-" : data?['keluar']['status']} "),
                  Text("jarak : ${data?['keluar'] == null ? "-" : "${data?['keluar']['jarak']} meter "}"),
                  Text("Alamat : ${data?['keluar'] == null ? "-" : data?['keluar']['alamat']}"),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
