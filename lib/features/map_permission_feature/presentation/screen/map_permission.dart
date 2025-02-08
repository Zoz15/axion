import 'package:axion/features/map_permission_feature/presentation/widgets/send_permission.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:axion/core/constants.dart';

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
