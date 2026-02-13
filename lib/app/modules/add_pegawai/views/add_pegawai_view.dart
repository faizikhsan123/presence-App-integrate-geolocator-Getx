import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AddPegawaiView'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
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
            controller: controller.emailC,
            decoration: InputDecoration(labelText: "EMAIL"),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.passC,
            decoration: InputDecoration(labelText: "Password"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text("Simpan"),
            onPressed: () => controller.addPegawai( //jalnkan fungsi
              controller.namaC.text,
              controller.nipC.text,
              controller.emailC.text,
              controller.passC.text,
            ),
          ),
        ],
      ),
    );
  }
}
