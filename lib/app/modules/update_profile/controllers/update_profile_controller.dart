import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UpdateProfileController extends GetxController {
  late TextEditingController nipC;
  late TextEditingController namaC;
  late TextEditingController emailC;
  late ImagePicker imagePicker = ImagePicker();
  RxBool isLoading = false.obs;
  RxBool uploadButton = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  XFile? pickedImage;

  String? imageUrl;

  Future<void> selectImage() async {
    try {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage = image;
      }
      update();
    } catch (e) {
      print(e);
      pickedImage = null;
      update();
    }
  }

  void deleteImage() {
    pickedImage = null;
    update();
  }

  


  void uploadImage() async {
    if (pickedImage == null) {

      Get.snackbar(
        "Error",
        "Gambar Harus dipilih",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      uploadButton.value = true;

      String? uid = auth.currentUser!.uid; 

      String cloudName = 'dvjnnntun'; 
      String uploadPreset = 'absensi'; 

      var url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      var request = http.MultipartRequest(
        'POST',
        url,
      ); 

      request.fields['upload_preset'] =
          uploadPreset; 
      request.files.add(
        await http.MultipartFile.fromPath('file', pickedImage!.path),
      ); 

      var response = await request.send(); 
      var resData = await response.stream.toBytes(); 
      var result = jsonDecode(String.fromCharCodes(resData),); 

      imageUrl = result['secure_url']; 

      await firestore.collection("pegawai").doc(uid).update({
       
        "photo": imageUrl,
      });

      Get.snackbar(
        'Berhasil',
        'Gambar berhasil diupload',
        backgroundColor: Colors.green,

        
      );

      uploadButton.value = false; 
    } catch (e) {
      uploadButton.value = false;
      print(e);
      Get.snackbar(
        "Error",
        "Gambar gagal diupload",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

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
