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

   FirebaseAuth auth = FirebaseAuth.instance; //inisialisasi firebase auth
  FirebaseFirestore firestore = FirebaseFirestore.instance; //inisialiasaasi firestore


  void hidepass(){
    isHide.toggle();
  }

  void login(String email, String pass) async {
    if (emailC.text.isEmpty || passC.text.isEmpty) {
      Get.snackbar('Gagal', 'Email dan Password Tidak Boleh Kosong');
    }
    try {

    UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: pass); //sekarang sign in atau login

    if (userCredential.user != null) { //jjika ada user dan emailnya sudah terverifikasi ,ambil ke halaman home
      if (userCredential.user!.emailVerified == true) { //email verified ini menandakan bahwa email sudah terverifikasi
           Get.offNamed(Routes.HOME);
          return;
      }
      Get.defaultDialog( //ini ada user tapi emailnya belum terverifikasi
        title: 'Verifikasi Email',
        middleText: 'Email Belum Terverifikasi, Silahkan Cek Email $email',
        onConfirm: ()  {
          userCredential.user!.sendEmailVerification(); //kirim email verifikasi ke email
          Get.back(); //tutup dialog
        },
      );
    } 
    } catch (e) {
      print(e);
      Get.snackbar('Gagal', 'Email atau Password Salah');
      
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    emailC = TextEditingController();
    passC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }
}
