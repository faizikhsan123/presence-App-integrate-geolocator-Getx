import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  const DetailPresensiView({Key? key}) : super(key: key);
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
                      "${DateFormat.yMMMEd().format(DateTime.now())}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Masuk", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Jam : ${DateFormat.jms().format(DateTime.now())} "),
                  Text("Posisi : -6.0000, 106.0000 "),
                  Text("Status : Di dalam area  "),
                  SizedBox(height: 20),
                  Text("keluar", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Jam : ${DateFormat.jms().format(DateTime.now())} "),
                  Text("Posisi : -6.0000, 106.0000  "),
                  Text("Status : Di dalam area  "),
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
