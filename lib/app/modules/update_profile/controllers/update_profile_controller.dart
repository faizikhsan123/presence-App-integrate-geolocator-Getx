import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  late TextEditingController nipC;
  late TextEditingController namaC;
  late TextEditingController emailC;
  late ImagePicker imagePicker = ImagePicker(); //import image picker

  XFile? pickedImage; //untuk menampung gambar

  void selectImage() async {
    try {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        //ketika user memilih gambar 
        pickedImage = image;
      
      }
      update(); //untuk memperbarui karena pakai get buildeedr
    } catch (e) { //kalo user klik cancel pada pemilihan gamabar
      print(e);
      pickedImage = null;
      update();
    }
  }

  void deleteImage(){
    pickedImage = null;
    update();
  }

  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateProfile(String email, String nip, String nama) async {
    isLoading.value = true;

    if (nipC.text.isEmpty || namaC.text.isEmpty || emailC.text.isEmpty) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "nip, nama, email Tidak Boleh Kosong",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    try {
      isLoading.value = true;
      String uid = auth.currentUser!.uid;
      CollectionReference pegawai = firestore.collection('pegawai');
      await pegawai.doc(uid).update({'nama': nama});

      Get.defaultDialog(
        title: 'Berhasil',
        middleText: 'akun berhasil diupdate',
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      isLoading.value = false;
      print(e);
      Get.snackbar(
        "Error",
        "akun tidak bisa diupdate",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onInit() {
    nipC = TextEditingController();
    namaC = TextEditingController();
    emailC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    nipC.dispose();
    namaC.dispose();
    emailC.dispose();
    super.onClose();
  }
}
