import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:ride/Screens/home_Screen.dart';
// import 'package:location/location.dart' as loc;
// import 'package:ride/Screens/map_Screen.dart';
import 'package:ride/manger/home_controller.dart';
import 'package:ride/var.dart';

Future<void> main() async {
  Get.put(HomeController(), permanent: true);
    WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // Initialize LocationController here as permanent
    // Get.put(LocationController(), permanent: true);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: '/home',
      // getPages: [
      //   GetPage(
      //     name: '/home',
      //     page: () => HomeScreen(),
      //   ),
      // ],
      home:  HomeScreen(),
    );
  }
}

// class test extends StatelessWidget {
//   const test({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: Container(
//         child: InkWell(
//             onTap: () async {
//               bool ifTure = await checkPermission();
//               if (ifTure == true) {
//                 Get.to(() => MapScreen());
//               } else {
//                 Get.snackbar('Error', 'Location permission denied');
//               }
//             },
//             child: Text('Hello World')),
//       )),
//     );
//   }
// }

// Future<bool> checkPermission() async {
//   loc.Location location = loc.Location();
//   // التحقق من تفعيل خدمات الموقع
//   bool serviceEnabled = await location.serviceEnabled();
//   if (!serviceEnabled) {
//     serviceEnabled = await location.requestService();
//     if (!serviceEnabled) {
//       print('Location services are disabled.');
//       Get.snackbar(
//           'Error', 'Location services are disabled. Please enable them.');
//       return false;
//     }
//   }

//   // التحقق من الأذونات
//   loc.PermissionStatus permissionGranted = await location.hasPermission();
//   if (permissionGranted == loc.PermissionStatus.denied) {
//     permissionGranted = await location.requestPermission();
//     if (permissionGranted != loc.PermissionStatus.granted) {
//       print('Location permission denied.');
//       Get.snackbar('Error', 'Location permission denied. Please allow it.');
//       return false;
//     }
//   }

//   // معالجة حالة deniedForever
//   if (permissionGranted == loc.PermissionStatus.deniedForever) {
//     print('Location permission permanently denied.');
//     Get.snackbar(
//       'Error',
//       'Location permission is permanently denied. Please enable it from app settings.',
//     );
//     return false;
//   }

//   // إذا تم التفعيل ووجود الإذن
//   print('Location services and permissions are enabled.');
//   return true;
// }
