import 'dart:async';

import 'package:axion/core/constants.dart';
import 'package:axion/features/splash_feature/presentation/mager/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget GetStartedButton_beforeAnimation() {
  final SplashWidgetController controller = Get.find();
    return InkWell(
      onTap: () {
        controller.onTap();
        Timer(Duration(milliseconds: 1000), () {
          Get.toNamed('/login');
        });
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