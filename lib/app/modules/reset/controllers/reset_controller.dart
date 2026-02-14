import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:presense_app/app/routes/app_pages.dart';

class ResetController extends GetxController {
  late TextEditingController emailC;

  FirebaseAuth auth = FirebaseAuth.instance;

  void forgetPass(String email) async {
    if (emailC.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Email Tidak Boleh Kosong",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      try {
       await auth.sendPasswordResetEmail(email: email);  //reset password melaui email 
        Get.snackbar(
          "Berhasil,pastikan email anda terdaftar yaa",
          "Silahkan Cek Email $email",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(Routes.LOGIN);
      } catch (e) {
        print(e);
        Get.snackbar(
          "Error",
          "Email Tidak Ditemukan",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    emailC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    // TODO: implement onClose
    super.onClose();
  }
}
