import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride/Screens/home_Screen.dart';
import 'package:ride/manger/splash_controller.dart';
import 'package:ride/var.dart';

class SplashWidget extends StatelessWidget {
  final SplashWidgetController controller = Get.put(SplashWidgetController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ContantInSplash(),
        GetStartedButton(),
      ],
    );
  }

  Widget GetStartedButton() {
    return SafeArea(
      child: Obx(
        () => AnimatedAlign(
          curve: Curves.easeInOutCubic,
          duration: Duration(milliseconds: 500),
          alignment: controller.isTaped.value
              ? Alignment.bottomCenter
              : Alignment.center,
          child: AnimatedPadding(
            duration: Duration(milliseconds: 500),
            padding: controller.isTaped.value
                ? EdgeInsets.only(bottom: 20)
                : EdgeInsets.all(0),
            child: TweenAnimationBuilder(
              tween: Tween<double>(
                  begin: 0, end: controller.isTaped.value ? 0 : 10),
              duration: const Duration(milliseconds: 500),
              builder: (context, double value, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                    width: controller.isTaped.value
                        ? screenWidth * 0.6
                        : screenWidth * 0.8,
                    height: controller.isTaped.value ? 70 : screenHeight / 1.5,
                    decoration: BoxDecoration(
                      color: controller.isTaped.value
                          ? pinkColor
                          : pinkColor.withOpacity(0.5),
                      borderRadius: controller.isTaped.value
                          ? BorderRadius.circular(20)
                          : BorderRadius.circular(50),
                    ),
                    child: controller.isTaped.value
                        ? GetStartedButton_beforeAnimation()
                        : GetStartedButton_afterAnimation(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget GetStartedButton_afterAnimation() {

    return Container(
        width: screenWidth * 0.6,
        height: 70,
        decoration: BoxDecoration(
          color: pinkColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            //todo login with google
            Get.to(HomeScreen());
            // controller.onTap();
            // Navigator.pushNamed(context, '/login');
          },
          child: Center(
            child: Text('Login With Google',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 20,
                )),
          ),
        ));
  }

  Widget GetStartedButton_beforeAnimation() {
    return InkWell(
      onTap: () {
        controller.onTap();
        // Navigator.pushNamed(context, '/login');
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Started',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: darkColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container ContantInSplash() {
    return Container(
      padding: EdgeInsets.all(20),
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GOOD MORNING',
                style: GoogleFonts.openSans(
                  color: pinkColor,
                  fontSize: 20,
                )),
            Text(
              'welcome to $appName',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Let\'s get started',
              style: GoogleFonts.openSans(
                color: pinkColor,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
