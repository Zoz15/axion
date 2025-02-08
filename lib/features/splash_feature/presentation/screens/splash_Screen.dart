import 'package:axion/features/splash_feature/presentation/widgets/getstart.dart';
import 'package:axion/features/splash_feature/presentation/widgets/splash_contant.dart';
import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
   
    SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ContantInSplash(),
          GetStartedButton(),
        ],
      ),
    );
  }
}
