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
          String alamat =
              "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";

          await updatePosisi(position, alamat);

          //cek jarak
         double jarak = Geolocator.distanceBetween(
            position.latitude, //latitude awal
            position.longitude, //longitude awal
        -7.9129394, //latitude tujuan
           112.6403355, //longitude tujuan
          );

          await presensi(position, alamat,jarak);
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

  Future<void> presensi(Position position, String alamat,double jarak) async {
    String uid = auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> presensi = await firestore
        .collection("pegawai")
        .doc(uid)
        .collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence = await presensi.get();

    DateTime now = DateTime.now();
    String todaydocId = DateFormat.yMd().format(now).replaceAll('/', '-');

    String status = 'Di luar area'; //nilai default status

    if (jarak <= 200) {
      status = 'Di dalam area'; //jika jarak <= 200 meter maka status = Di dalam area
    }

    if (snapPresence.docs.length == 0) {
      await presensi.doc(todaydocId).set({
        "date": now.toIso8601String(),
        "masuk": {
          "date": now.toIso8601String(),
          "latitude": position.latitude,
          "longitude": position.longitude,
          "alamat": alamat,
          "status": status, //ganti ini
          "jarak" : jarak //tambahkan ini di firestore
        },
      });
      Get.snackbar('Berhasil', 'Berhasil Absensi Masuk ');
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDoc = await presensi
          .doc(todaydocId)
          .get();

      if (todayDoc.exists == true) {
        Map<String, dynamic> datapresensiToday = todayDoc.data()!;
        if (datapresensiToday["keluar"] != null) {
          Get.snackbar('Success', 'Anda sudah absen masuk dan keluar');
          return;
        } else {
          await presensi.doc(todaydocId).update({
            "keluar": {
              "date": now.toIso8601String(),
              "latitude": position.latitude,
              "longitude": position.longitude,
              "alamat": alamat,
              "status": status, //ganti ini
              "jarak" : jarak //tambahkan ini di firestore
            },
          });
          Get.snackbar('Success', 'Berhasil Absensi Keluar');
        }
      } else {
        await presensi.doc(todaydocId).set({
          "date": now.toIso8601String(),
          "masuk": {
            "date": now.toIso8601String(),
            "latitude": position.latitude,
            "longitude": position.longitude,
            "alamat": alamat,
            "status": status, //ganti ini
            "jarak" : jarak //tambahkan ini di firestore
          },
        });
        Get.snackbar('Success', 'Berhasil Absensi Masuk');
      }
    }
  }

  Future<void> updatePosisi(Position position, String alamat) async {
    String uid = auth.currentUser!.uid;
    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "latitude": position.latitude,
        "longitude": position.longitude,
      },
      "alamat": alamat,
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
