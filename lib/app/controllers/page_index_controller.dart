import 'package:get/get.dart';
import 'package:presense_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; //import library geolocator

class PageIndexController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changePage(index) async {
    switch (index) {
      case 1:
        currentIndex.value = index;
        //pas pindah page jalankan functioniinii
        Map<String, dynamic> dataResponse = await posisiTerkini();
        if (dataResponse["error"] == false) { //jika data responose mapping key error false
        Position position = dataResponse["position"]; //ambil key position dari mapping dibawah
        Get.snackbar('${dataResponse["message"]}', "posisi anda ${position.latitude}, ${position.longitude}");
        
        }else { //jika data responose mapping key error true
          Get.snackbar(
            "Error",
            dataResponse["message"],
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      
        //latitude artinya di barat dan longitude artinya di timur posisi kita
        break;
      case 2:
        currentIndex.value = index;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        currentIndex.value = index;
        Get.offAllNamed(Routes.HOME);
    }
  }


  Future<Map<String, dynamic>> posisiTerkini() async {
    //ubah ke bent mapping
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return { 
      "message" : "tidak dapat mengambil gps terkini",
      "error" : true
    };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          "message": "izin menggunakan gps telah ditolak", 
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        "message": "Settingan hp tidak mengizinkan akses lokasi permanen",
        "error": true,
      };
    }

    Position position = await Geolocator.getCurrentPosition(); //ini berhasil mengambil posisi
    return {
      //mengembalikan nilai dalam bentuk map
      "position": position,
      "message": "berhasil mendapatkan posisi terkini",
      "error": false,
    };
  }
}
