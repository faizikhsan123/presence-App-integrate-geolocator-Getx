import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:presense_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> profileStream() {
    String uid = auth.currentUser!.uid;
    return firestore.collection("pegawai").doc(uid).snapshots();
  }

  void logout() async {
    await auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> deletePhoto() async {
    Get.defaultDialog(
      title: 'Hapus Foto',
      middleText: 'Apakah anda yakin ingin menghapus foto?',
      onCancel: () {},
      onConfirm: () async {
        String uid = auth.currentUser!.uid;
        await firestore.collection("pegawai").doc(uid).update({"photo": null});

        Get.back();
      },
    );
  }
}
