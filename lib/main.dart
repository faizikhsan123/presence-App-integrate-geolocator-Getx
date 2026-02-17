import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presense_app/app/controllers/page_index_controller.dart';
import 'package:presense_app/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final pageC = Get.put(PageIndexController(),permanent: true); //letakkan controller pageindexcontroller disini karena akan dipakai di tiap halaman
 
  runApp(Myapp());
}


class Myapp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, asyncSnapshot) {
        print(asyncSnapshot.data);

        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Application",
          initialRoute:
              asyncSnapshot.data == null ? Routes.LOGIN : Routes.HOME,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
