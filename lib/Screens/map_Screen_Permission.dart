import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ride/Screens/map_Screen.dart';
import 'package:ride/var.dart';

class MapScreenPermission extends StatelessWidget {
  const MapScreenPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.5,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Lottie.asset(
                          'assets/json/map.json',
                          filterQuality: FilterQuality.low,
                          frameRate: FrameRate(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    'We need your location to show your location',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Please enable location',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    width: screenWidth / 1.9,
                    height: 60,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: pinkColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Text(
                      'Enable Location',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> onTap() async {
  print('onTap');

  // First attempt to enable location and get permissions
  if (await Geolocator.isLocationServiceEnabled() == false) {
    await Geolocator.openLocationSettings();
    // Add delay to allow user to change settings
    await Future.delayed(Duration(seconds: 2));
  }

  if (await Geolocator.checkPermission() == LocationPermission.denied) {
    await Geolocator.requestPermission();
    // Add delay to allow user to respond to permission request
    await Future.delayed(Duration(seconds: 2));
  }

  if (await Geolocator.checkPermission() == LocationPermission.deniedForever) {
    await Geolocator.openLocationSettings();
    // Add delay to allow user to change settings
    await Future.delayed(Duration(seconds: 2));
  }

  // Check final status
  final permission = await Geolocator.checkPermission();
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  print(permission);
  print(isLocationEnabled);
  print('-----------------------------------------------');

  if ((permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) &&
      isLocationEnabled) {
    Get.back();
    Future.delayed(Duration(milliseconds: 200), () {
      Get.to(MapScreen());
    });
  }
}


// class LocationSettingsExample extends StatefulWidget {
//   @override
//   _LocationSettingsExampleState createState() =>
//       _LocationSettingsExampleState();
// }

// class _LocationSettingsExampleState extends State<LocationSettingsExample> {
//   Future<void> checkLocationService() async {
//     // تحقق من إذن الموقع
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       await Geolocator.requestPermission();
//     }

//     // تحقق إذا كان GPS مفعلًا
//     bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!isLocationEnabled) {
//       // إذا كان الموقع معطلاً، أظهر Snackbar
//       showSnackBar();
//     }
//   }

//   void showSnackBar() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('الرجاء تفعيل الموقع من الإعدادات'),
//         action: SnackBarAction(
//           label: 'فتح الإعدادات',
//           onPressed: () async {
//             // فتح إعدادات الموقع
//             await Geolocator.openLocationSettings();
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Location Example')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: checkLocationService,
//           child: Text('تحقق من الموقع'),
//         ),
//       ),//     );
//   }
// }