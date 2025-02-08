import 'package:axion/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget ContantInSplash() {
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