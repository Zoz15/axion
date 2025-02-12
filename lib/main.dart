import 'package:axion/core/roatename.dart';
import 'package:axion/features/home_feature/presentation/screens/home_screen.dart';
import 'package:axion/features/map_feature/data/mapurl/change_map.dart';
import 'package:axion/features/signup_feature/presentation/screen/verification.dart';
import 'package:axion/features/splash_feature/presentation/mager/splash_controller.dart';
import 'package:axion/features/splash_feature/presentation/screens/splash_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axion/features/home_feature/presentation/manger/home_controller.dart';
import 'package:axion/core/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(HomeController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(
            '-----------------------------------------------User is currently signed out!');
      } else {
        print(
            '-----------------------------------------------User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    getLinkMapFromStroage();

    Get.put(SplashWidgetController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null 
          ? SplashWidget()
          : FirebaseAuth.instance.currentUser!.emailVerified == false
              ? Verification()
              : HomeScreen(),
      getPages: routes,
    );
  }
}
