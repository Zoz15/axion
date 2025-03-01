import 'package:axion/core/constants.dart';
import 'package:axion/features/home2_feature/presentation/widgets/chack_location.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget startCyclingButtom() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTapChickLocation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: pinkColor,
          ),
          height: 60,
          width: screenWidth * .6,
          // color: pinkColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Start Cycling',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(width: 10),
              Container(
                height: 35,
                width: 35,
                padding: EdgeInsets.all(8),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: darkColor),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    lightColor,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'assets/images/icon_photo.png',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
