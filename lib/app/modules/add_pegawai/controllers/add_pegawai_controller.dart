import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  late TextEditingController nipC;
  late TextEditingController namaC;
  late TextEditingController emailC;
  late TextEditingController passC;
  late TextEditingController passAdmin; //textfield password admin (untuk validasi)

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
      //jika tidak kosong
      Get.defaultDialog(
        title: 'Validasi admin',
        content: Column(
          //content seperti middle textt namun dia make widget
          children: [
            TextField(
              controller: passAdmin,
              autocorrect: false,
              decoration: InputDecoration(hintText: "Masukkan Password"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () => Get.back(), child: Text("cancel")),
          ElevatedButton(onPressed: () async {
          await prosesAddPegawai(); //jalnkan function idbawah
          }, child: Text("Add pegawai")),
        ],
      );
    }
  }

  Future prosesAddPegawai() async {
    //function tambah pegawai kita pecah jadi
    if (passAdmin.text.isEmpty) {
      //jika password admin kosong validasi
      Get.snackbar(
        "Error",
        "Password wajib diisi untuk keperluan validasi",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return; //maka tidak bisa dijalankan koode berikutnya
    }
    try {
      //jika dia bener admin maka bisa tambah pegawai
      String emailAdmin = auth.currentUser!.email!; //ini email admin skearang

      //ambil admin credential emailnya dari email yg sedang login passwordnya diambil dari pass admin 
      UserCredential adminCredential = await auth.signInWithEmailAndPassword(email: emailAdmin, password: passAdmin.text);

      if (adminCredential.user == null) { //jika tidak ditemukan
       Get.defaultDialog(
        title: 'Error',
        middleText: 'Password Admin Salah',
        onConfirm: () => Get.back(),
       );
      }


      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailC.text,
        password: passC.text,
      );

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

        await userCredential.user!.sendEmailVerification();

        await auth.signOut(); //jadi pas nambah pegawai current usernya = null kita logout

        UserCredential adminCredential = await auth.signInWithEmailAndPassword(email: emailAdmin, password: passAdmin.text); //trs di reloginnd dengangan akun admin

        Get.defaultDialog(
          title: 'Success',
          middleText:
              'Pegawai Berhasil Ditambahkan dan kami sudah mengirimkan verifikasi ke email',
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


  void onInit() {
    nipC = TextEditingController();
    namaC = TextEditingController();
    emailC = TextEditingController();
    passC = TextEditingController();
    passAdmin = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    nipC.dispose();
    namaC.dispose();
    emailC.dispose();
    passC.dispose();
    passAdmin.dispose();
    super.onClose();
  }
}
