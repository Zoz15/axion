import 'package:flutter/material.dart';

double screenWidth = 0;
double screenHeight = 0;

String appName = 'Axion';
Curve curve = Curves.easeInOutCubic;

Color pinkColor = Color(0xffc41e5c);
Color darkColor = Color(0xff151c26);
Color lightOfDarkColor = Color(0xff223546);
Color lightColor = Color(0xffe1e1d0);
Color lightBlue = Color.fromARGB(255, 174, 213, 255);

Color blackColor = Color(0xff060607);
Color grayColor = Color(0xff212120);
Color deepgrayColor = Color(0xff141515);
Color orangeColor = Color(0xffFD6912);
Color whiteColor = Color(0xfff7f6f6);
double defaultRadius = 30.0;

var mapLinks = <String>[
  'http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
  // 'http://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}.png',
  'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  'http://{s}.tile.thunderforest.com/cycle/{z}/{x}/{y}.png',
  'http://{s}.tile.thunderforest.com/transport/{z}/{x}/{y}.png',
  'http://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png',
  'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
  // 'http://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png',
];

String theMapUrl = 'http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
