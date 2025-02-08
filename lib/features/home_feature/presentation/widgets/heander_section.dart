import 'package:axion/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget headerSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Hi data',
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: lightColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Let\'s cycle!',
          style: GoogleFonts.orbitron(
            fontSize: 40,
            color: lightColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
