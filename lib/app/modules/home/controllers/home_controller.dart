import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presense_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs; 

  FirebaseFirestore firestore = FirebaseFirestore.instance;

 
  Future logout() async {
    isLoading.value = true; 
    await auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> roleStream(){ 
    String uid = auth.currentUser!.uid; 

    return firestore.collection("pegawai").doc(uid).snapshots(); 
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> presenceStream(){
    String uid = auth.currentUser!.uid;
    //ambil di sub collectio presence diurutkan  berdasarkan date 
    //lalu hanya ambil 5 data terakhir
    return firestore.collection("pegawai").doc(uid).collection("presence").orderBy("date").limitToLast(5).snapshots();
  }

 }
