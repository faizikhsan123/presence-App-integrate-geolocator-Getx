import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:presense_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController passC;
  RxBool isHide = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs; //taambahkan ini

  void hidepass() {
    isHide.toggle();
  }

  Future<void> login(String email, String pass) async {
    isLoading.value = true; //ganri nilainya ketika function dijalankan
    if (emailC.text.isEmpty || passC.text.isEmpty) {
      Get.snackbar('Gagal', 'Email dan Password Tidak Boleh Kosong');
    }
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified == true) {
          isLoading.value = true; //ganti nilainya kalo ada user dan sudah verifikasi
          Get.offNamed(Routes.HOME);
          return;
        }
        Get.defaultDialog(
          title: 'Verifikasi Email',
          middleText: 'Email Belum Terverifikasi, Silahkan Cek Email $email',
          onConfirm: () {
            userCredential.user!.sendEmailVerification();
            isLoading.value = false; //nilainya kemablai ke false kalo ada user dan belum verifikasi
            Get.back();
          },
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar('Gagal', 'Email atau Password Salah');
      isLoading.value = false; //error maka nilainya kembali false
    }
  }

  @override
  void onInit() {
    emailC = TextEditingController();
    passC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}
