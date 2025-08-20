import 'package:axion/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            // Get.to(HomeScreen());
          },
          child: Center(
            child: Text('beta version',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 20,
                )),
          ),
        ));
  }