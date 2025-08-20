import 'package:axion/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget TopProfileHome() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: orangeColor, width: 1.5),
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          SvgPicture.asset(
            "assets/svg/notification.svg",
            height: 28,
          )
        ],
      ),
      SizedBox(height: 20),
      Text('Hi, Mostafa! 👋🏻', style: TextStyle(fontSize: 30)),
      SizedBox(height: 10),
      Text('Where will we go today?',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
      SizedBox(height: 20),
      Divider(color: Colors.grey),
    ],
  );
}
