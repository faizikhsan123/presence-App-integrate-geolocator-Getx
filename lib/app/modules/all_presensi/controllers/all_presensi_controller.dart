import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresensiController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime? start; //tanggal awal = null
  DateTime end = DateTime.now(); //tanggal akhir yaitu tanggal sekarang

  Future<QuerySnapshot<Map<String, dynamic>>> AllpresenceFuture() async {
    //ganti ke future builder saja
    String uid = auth.currentUser!.uid;

    if (start == null) { //get semua presence
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where("date", isLessThan: end.toIso8601String()) //kita ambil data sebelum tanggal sekarang ini trs kenapa itu di iso string karena firebase membutuhkan tipe data string
          .orderBy("date", descending: true)
          .get();
    } else {
      return firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where("date", isGreaterThan: start!.toIso8601String()) //dimana tanggal sekarang(21) lebih besar dari start (<= 21)
          .where("date", isLessThan: end.add(Duration(days: 1)).toIso8601String()) //diamna tanggal 21 hari lebih kecil dari end <= 22 (tanggal sekarang + 1 hari)
          .orderBy("date", descending: true)
          .get();
    }

  }
  void pickDate(DateTime pickStart, DateTime pickEnd) { //untuk mengubah nilai start dan end tanggal
    start = pickStart;
    end = pickEnd;
    update();
    Get.back();
  }
}
