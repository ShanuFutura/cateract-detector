import 'package:cateract_detector/constants.dart';
import 'package:cateract_detector/pages/admin/admin_home.dart';
import 'package:cateract_detector/pages/doctor/doctor_home_page.dart';
import 'package:cateract_detector/pages/loading_splash.dart';
import 'package:cateract_detector/pages/login_page.dart';
import 'package:cateract_detector/pages/user/user_home.dart';
import 'package:cateract_detector/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // String? load = await Tflite.loadModel(
  //   model: 'assets/converted_modelcatt.tflite',
  //   // labels: 'assets/labels.txt',
  // );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // useMaterial3: true,
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Constants.firebaseUser = snapshot.data!;
FirebaseServices.loginByePass(context);
                return FutureBuilder(
                    future: FirebaseServices.getUserType(snapshot.data!.uid),
                    builder: (context, snap) {
                      if (snap.data == UserType.doctor) {
                        return const DoctorHomePage();
                      } else if (snap.data == UserType.patient) {
                        return const UserHomePage();
                      } else if (snap.data == UserType.admin) {
                        return const AdminHome();
                      } else {
                        return const LoadingSplash();
                      }
                    });
              } else {
                return const LoginPage();
              }
            }));
  }
}
