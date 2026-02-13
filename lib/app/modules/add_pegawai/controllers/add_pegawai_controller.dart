import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  late TextEditingController nipC;
  late TextEditingController namaC;
  late TextEditingController emailC;
  late TextEditingController passC;

  FirebaseAuth auth = FirebaseAuth.instance; //inisialisasi firebase auth
  FirebaseFirestore firestore = FirebaseFirestore.instance; //inisialiasaasi firestore

  void addPegawai(String name, String nip, String email,String pass) async {
    //fungsi add pegawai
    if (nipC.text.isEmpty || namaC.text.isEmpty || emailC.text.isEmpty) {
      //jika kosong
      Get.snackbar(
        "Error",
        "nip, nama, email Tidak Boleh Kosong",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      //jika tidak kosong 
      //sekarang kita pakai create bukan sign in jadi dia bikin akunm baru di authentication firebase bukan login
      
      try {
       UserCredential userCredential = await auth.createUserWithEmailAndPassword( //userCredential adalah hasil dari create akun
          email: emailC.text,
          password: passC.text,
        );

        print(userCredential); //data akun yg dibuat

        
        String uid = userCredential.user!.uid; //uid dari akun yg dibuat


        CollectionReference pegawai = firestore.collection('pegawai'); //collection pegawai

         //set ini dia bikin doc baru di collection pegawai namun id doc nya dibuat dari uid diatas
         //berbeda dengan add dia buat doc baru namun id doc nyas di generate secara otomatis
        await pegawai.doc(uid).set({
          'nip': nipC.text, //dari textfield
          'nama': namaC.text,
          'email': emailC.text,
          'pass': passC.text,
          'uid': uid, //dari uid yg dibuat diatas
          'createdAt': DateTime.now().toIso8601String(),

        }); 
       

        Get.defaultDialog(
          title: 'Success',
          middleText: 'Pegawai Berhasil Ditambahkan',
          onConfirm: () {
            Get.back();
            Get.back();
          }
        );

       
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

