import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presense_app/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 
  runApp(Myapp());
}

class Myapp extends StatelessWidget {

   FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(), //cek apakah ada user atau tidak ini juga bisa menyiman auth yg login
      //namun ini juga bisa misal ketika dia buat akun baru maka current user akan berubah bukan user yg sudah login sebelumnya
      builder: (context, asyncSnapshot) {
        print(asyncSnapshot.data); //melihat ada ga datannya di terminal
      
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Application",
          initialRoute: asyncSnapshot.data == null ? Routes.LOGIN : Routes.HOME, //jika tidak ada user maka langsung ke halaman login //jika ada user langsung ke halaman home
          getPages: AppPages.routes,
        );
      }
    );
  }
}
