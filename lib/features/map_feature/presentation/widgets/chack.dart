
import 'package:axion/core/constants.dart';
import 'package:axion/features/map_feature/presentation/manger/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget isInSaveMood() {
  final controller = Get.find<MyMapController>();
  return Align(
    alignment: Alignment.center,
    child: Container(
      height: screenHeight / 6,
      width: screenWidth - 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: pinkColor, width: 2),
        color: darkColor,
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Battery Saver Mode is ON",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Please turn it off",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              TextButton(
                  onPressed: () {
                    controller.isBatterySaveMode.value = false;
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ),
        ],
      ),
    ),
  );
}
