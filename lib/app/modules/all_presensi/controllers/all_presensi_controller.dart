import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresensiController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

   Stream<QuerySnapshot<Map<String, dynamic>>> AllpresenceStream() {
    String uid = auth.currentUser!.uid;

    return firestore
        .collection("pegawai")
        .doc(uid)
        .collection("presence")
        .orderBy("date",descending: true)
        .snapshots();
  }
}
