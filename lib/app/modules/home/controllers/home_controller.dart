import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presense_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs; //tambahkan isLoading
 
  Future logout() async {
    isLoading.value = true; //ketika logout isLoading nilainya true
    await auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
