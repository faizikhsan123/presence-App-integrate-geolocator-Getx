import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:presense_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  
  Stream<DocumentSnapshot<Map<String, dynamic>>> profileStream()  { //stream
    String uid =  auth.currentUser!.uid; //ambil uid yg login
    return firestore.collection("pegawai").doc(uid).snapshots(); //ambil dari collection chats dan document uid yg sedang login

  }

  void logout() async { //fungsi logfout
    await auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
