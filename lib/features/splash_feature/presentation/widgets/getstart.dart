 import 'dart:ui';

import 'package:axion/core/constants.dart';
import 'package:axion/features/splash_feature/presentation/mager/splash_controller.dart';
import 'package:axion/features/splash_feature/presentation/widgets/getstart_after.dart';
import 'package:axion/features/splash_feature/presentation/widgets/getstart_before.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget GetStartedButton() {
  final SplashWidgetController controller = Get.find();
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
