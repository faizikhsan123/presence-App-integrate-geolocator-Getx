import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presense_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; 

class PageIndexController extends GetxController {
  RxInt currentIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(index) async {
    switch (index) {
      case 1:
        currentIndex.value = index;

        Map<String, dynamic> dataResponse = await posisiTerkini();
        if (dataResponse["error"] == false) {
          Position position = dataResponse["position"];
          List<Placemark> placemarks = await placemarkFromCoordinates(
            
            position.latitude, 
            position.longitude, 
          );
          String alamat = "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}"; 

          await updatePosisi(position,alamat); 

          await presensi(position, alamat); //function presensi

          Get.snackbar(
            'Berhasil',
            "Presensi Berhasil",
            backgroundColor: Colors.green,
          );
        } else {
          Get.snackbar(
            "Error",
            dataResponse["message"],
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
          );
        }

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

  Future<void> presensi(Position position, String alamat) async { //function presensi
    String uid = auth.currentUser!.uid;
    //buat sub collection di pegawai dengan nama presence tiap pegawai
   CollectionReference<Map<String, dynamic>> presensi = await firestore.collection("pegawai").doc(uid).collection("presence"); 

   QuerySnapshot<Map<String, dynamic>> snapPresence = await presensi.get();  //kita ambil dulu sub collection presence

  DateTime now = DateTime.now(); //ini untuk doc id sub collection presence
  String todaydocId = DateFormat.yMd().format(now).replaceAll('/', '-'); //format tanggal
  

   if (snapPresence.docs.length == 0) { //jika sub collection presence masih kosong (belum pernah absen satupun)
   await presensi.doc(todaydocId).set({ //buat absen pertama
      "date" : now.toIso8601String(), //ini dipakai untuk mengurutkan sub collection
      "masuk" : {
       "date" : now.toIso8601String(),
       "latitude" : position.latitude,
       "longitude" : position.longitude,
       "alamat" : alamat,
       "status" : "Di dalam area"
      }
   });

   }else {
    //sudah pernah absen -> cek hari ini sudah absen atau belum
    await presensi.doc(todaydocId).update({
      
    });

   }

   

    
  }

  Future<void> updatePosisi(Position position,String alamat) async { 
    String uid = auth.currentUser!.uid;
    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "latitude": position.latitude,
        "longitude": position.longitude,
      },
      "alamat": alamat 
    });
  }

  Future<Map<String, dynamic>> posisiTerkini() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {"message": "tidak dapat mengambil gps terkini", "error": true};
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {"message": "izin menggunakan gps telah ditolak", "error": true};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        "message": "Settingan hp tidak mengizinkan akses lokasi permanen",
        "error": true,
      };
    }

    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "berhasil mendapatkan posisi terkini",
      "error": false,
    };
  }
}
