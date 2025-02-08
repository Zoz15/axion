import 'package:axion/features/splash_feature/presentation/screens/splash_Screen.dart';
import 'package:axion/features/splash_feature/presentation/mager/splash_controller.dart';
import 'package:axion/core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              'Settings',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
            Spacer(),
            _chouseMap(),
            SizedBox(height: 20),
            Text(
              'this is beta version of app and it\'s not ready yet',
              style: GoogleFonts.poppins(color: lightColor),
            ),
            Text('if you have any problem ',
                style: GoogleFonts.poppins(color: lightColor)),
            Text('please contact me blow',
                style: GoogleFonts.poppins(color: Colors.red)),
            Text(
              'this app make with ❤️ by axon',
              style: GoogleFonts.poppins(color: lightColor),
            ),
            InkWell(
              onTap: () async {
                final manger = Get.find<SplashWidgetController>();
                FirebaseAuth.instance.signOut();
                
                await GoogleSignIn().signOut();
                manger.isTaped.value = false;
                Get.offAll(SplashWidget());
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Myimage(
                  image:
                      'https://imgs.search.brave.com/gATjGUzjNx5LO1NE_BV5DUcuKt9q9Y0I5b6q6vyzHJY/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMuc3RpY2twbmcu/Y29tL2ltYWdlcy81/ODBiNTdmY2Q5OTk2/ZTI0YmM0M2M1NDMu/cG5n',
                  ontap: () async {
                    final url = Uri.parse(
                        'https://wa.me/201223237666?text=I%20need%20to%20tell%20you%20think%20about%20you%20app%20(Axion)');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                ),
                SizedBox(width: 20),
                Myimage(
                  image:
                      'https://imgs.search.brave.com/LDSrUq-XZMltrCxfVsc1XAmSqSG_c6J1JW-0ErfJCD4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy9l/L2U3L0luc3RhZ3Jh/bV9sb2dvXzIwMTYu/c3Zn',
                  ontap: () async {
                    final url =
                        Uri.parse('https://www.instagram.com/axon_plus/');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget Myimage({required String image, required void Function()? ontap}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: InkWell(
      onTap: ontap,
      child: SizedBox(
        height: 60,
        width: 60,
        child: Image.network(
          image,
          // height: 120,
          // width: 120,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Widget _chouseMap() {
  // final controller = Get.find<MyMapController>();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      // height: 50,
      width: screenHeight - 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: pinkColor.withOpacity(.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: mapLinks.map((link) {
            return InkWell(
              onTap: () {
                theMapUrl = link;
                print(link);
                _saveText(link);
              },
              child: Container(
                height: (screenWidth / 3) - 18,
                width: (screenWidth / 3) - 18,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: darkColor,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: IgnorePointer(
                  child: FlutterMap(
                    options: MapOptions(
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.pinchZoom |
                            InteractiveFlag.none, // السماح بالتكبير/التصغير فقط
                      ),
                      backgroundColor: darkColor,
                      initialCenter: LatLng(31.211911, 29.910300),
                      initialZoom: 12.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: link,
                        subdomains: ['a', 'b', 'c', 'd'], // قائمة نطاقات الخادم
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

Future<void> _saveText(String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('text', value);
}
