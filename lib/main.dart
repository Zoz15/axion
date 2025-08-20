import 'package:axion/core/roatename.dart';
import 'package:axion/features/home2_feature/presentation/manger/home_controller.dart';
import 'package:axion/features/home2_feature/presentation/screens/home_screen.dart';
import 'package:axion/features/signup_feature/presentation/screen/verification.dart';
import 'package:axion/features/splash_feature/presentation/mager/splash_controller.dart';
import 'package:axion/features/splash_feature/presentation/screens/splash_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axion/core/constants.dart';

// مهم: استورد firebase_options.dart بعد ما تعمل flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(HomeController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('-------------------------------- User signed out!');
      } else {
        print('-------------------------------- User signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    Get.put(SplashWidgetController());

    return GetMaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: orangeColor,
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? SplashWidget()
          : FirebaseAuth.instance.currentUser!.emailVerified == false
              ? Verification()
              : HomeScreen2(),
      getPages: routes,
    );
  }
}
