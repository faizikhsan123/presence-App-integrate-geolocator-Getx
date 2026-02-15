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

  Stream<DocumentSnapshot<Map<String, dynamic>>> roleStream(){ //ini sttream
    String uid = auth.currentUser!.uid; //ambil uid yg login

    return firestore.collection("pegawai").doc(uid).snapshots(); //ambil collection chats berdasarkan document uid
  }
}
