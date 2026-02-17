import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presense_app/app/routes/app_pages.dart';

class AddPegawaiController extends GetxController {
  late TextEditingController nipC;
  late TextEditingController namaC;
  late TextEditingController jobC;
  late TextEditingController emailC;
  late TextEditingController passC;
  late TextEditingController passAdmin;
  RxBool isLoading = false.obs; //tambahkan ini
  RxBool isLoadingAddPegawai = false.obs; //tambahkan ini

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPegawai(String name, String nip, String email, String pass) async {
    if (nipC.text.isEmpty || namaC.text.isEmpty || emailC.text.isEmpty || jobC.text.isEmpty) { //+validasi
      Get.snackbar(
        "Error",
        "nip, nama,job dan email Tidak Boleh Kosong",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      isLoading.value = true; 
      Get.defaultDialog(
        title: 'Validasi admin',
        content: Column(
          children: [
            TextField(
              controller: passAdmin,
              autocorrect: false,
              decoration: InputDecoration(hintText: "Masukkan Password"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: Text("cancel"),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingAddPegawai.value == false) {
                  //ketika add pegawai isLoadingAddPegawai nilainya false
                  await prosesAddPegawai();
                }
              },
              child:
                  isLoadingAddPegawai.value ==
                      false //ketika add pegawai isLoadingAddPegawai nilainya false
                  ? Text("Add Pegawai")
                  : Text("Loading..."),
            ),
          ),
        ],
      );
    }
  }

  Future prosesAddPegawai() async {
    isLoading.value = true; //ketika add pegawai isLoading nilainya true
    isLoadingAddPegawai.value = true;

    if (passAdmin.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Password wajib diisi untuk keperluan validasi",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      isLoadingAddPegawai.value = false;
      return;
    }

    try {
      String emailAdmin = auth.currentUser!.email!;

      UserCredential adminCredential = await auth.signInWithEmailAndPassword(
        email: emailAdmin,
        password: passAdmin.text,
      );

      if (adminCredential.user == null) {
        Get.snackbar(
          "Error",
          "Password Salah",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        isLoadingAddPegawai.value = false;
        return;
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
          "job" : jobC.text, //tambah ini
          'email': emailC.text,
          'pass': passC.text,
          'uid': uid,
          "photo": null,
          "role" : "pegawai", 
          'createdAt': DateTime.now().toIso8601String(),
        });

        await userCredential.user!.sendEmailVerification();

        await auth.signOut();

        UserCredential adminCredential = await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdmin.text,
        );

        isLoading.value = false;
        isLoadingAddPegawai.value = false;

        Get.defaultDialog(
          title: 'Success',
          middleText:
              'Pegawai Berhasil Ditambahkan dan kami sudah mengirimkan verifikasi ke email',
          onConfirm: () {
            Get.offAllNamed(Routes.HOME);
          },
        );
      }
    } catch (e) {
      print(e);
      isLoading.value = false;
      isLoadingAddPegawai.value = false;
    }
  }

  void onInit() {
    nipC = TextEditingController();
    namaC = TextEditingController();
    jobC = TextEditingController();
    emailC = TextEditingController();
    passC = TextEditingController();
    passAdmin = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    nipC.dispose();
    namaC.dispose();
    jobC.dispose();
    emailC.dispose();
    passC.dispose();
    passAdmin.dispose();
    super.onClose();
  }
}
