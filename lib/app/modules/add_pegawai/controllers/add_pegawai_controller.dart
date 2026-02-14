import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  late TextEditingController nipC;
  late TextEditingController namaC;
  late TextEditingController emailC;
  late TextEditingController passC;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPegawai(String name, String nip, String email, String pass) async {
    if (nipC.text.isEmpty || namaC.text.isEmpty || emailC.text.isEmpty) {
      Get.snackbar(
        "Error",
        "nip, nama, email Tidak Boleh Kosong",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      try {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(
              email: emailC.text,
              password: passC.text,
            );

        print(userCredential);

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;

          CollectionReference pegawai = firestore.collection('pegawai');

          await pegawai.doc(uid).set({
            'nip': nipC.text,
            'nama': namaC.text,
            'email': emailC.text,
            'pass': passC.text,
            'uid': uid,
            'createdAt': DateTime.now().toIso8601String(),
          });

          await userCredential.user!.sendEmailVerification(); //jadi pas dia dafatarin akun emailnya juga dikirim verfikasi email

          Get.defaultDialog(
            title: 'Success',
            middleText: 'Pegawai Berhasil Ditambahkan dan jangan Lupa Verifikasi EmailNya',
            onConfirm: () {
              Get.back();
              Get.back();
            },
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void onInit() {
    super.onInit();
    nipC = TextEditingController();
    namaC = TextEditingController();
    emailC = TextEditingController();
    passC = TextEditingController();
  }

  @override
  void onClose() {
    nipC.dispose();
    namaC.dispose();
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}
