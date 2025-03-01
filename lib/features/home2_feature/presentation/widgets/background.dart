import 'dart:ui';

import 'package:axion/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية السوداء
        Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/orangeCircleBlur2.png'),
                fit: BoxFit.cover),
            color: blackColor,
          ),
        ),

        // العنصر البرتقالي
        // Positioned(
        //   top: 70,
        //   left: screenWidth / 2 - 20,
        //   child: SvgPicture.asset(
        //     'assets/svg/orangeCircleBlur2.svg',
        //     height: screenHeight,
        //   ),
        // ),
      ],
    );
  }
}
