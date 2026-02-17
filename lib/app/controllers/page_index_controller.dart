import 'package:get/get.dart';
import 'package:presense_app/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt currentIndex = 0.obs; //index halaman

  void changePage(index) {
  
    switch (index) {
      case 1:
        currentIndex.value = index;
      print("cetak absensi");
        break;
      case 2:
       currentIndex.value = index;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default: //default ini kalo tidak ada yg dipilih
        currentIndex.value = index;
        Get.offAllNamed(Routes.HOME);
    }
  }
}
