// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:axion/Screens/home_Screen.dart';
// // import 'package:location/location.dart' as loc;
// // import 'package:axion/Screens/map_Screen.dart';
// import 'package:axion/manger/home_controller.dart';
// import 'package:axion/var.dart';
// import 'package:permission_handler/permission_handler.dart';
// // import 'package:background_locator/background_locator.dart';

// void main() async {
//   Get.put(HomeController(), permanent: true);
//   requestNotificationPermission();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.of(context).size.width;
//     screenHeight = MediaQuery.of(context).size.height;

//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

// Future<void> requestNotificationPermission() async {
//   // Check if the permission is already granted
//   var status = await Permission.notification.status;
//   if (status.isDenied) {
//     // Request the permission
//     status = await Permission.notification.request();
//   }

//   if (status.isGranted) {
//     print("Notification permission granted");
//   } else if (status.isPermanentlyDenied) {
//     openAppSettings();
//   }
// }
