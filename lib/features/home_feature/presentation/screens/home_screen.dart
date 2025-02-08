import 'package:axion/features/home_feature/data/delete_route.dart';
import 'package:axion/features/home_feature/presentation/widgets/analysis.dart';
import 'package:axion/features/home_feature/presentation/widgets/heander_section.dart';
import 'package:axion/features/home_feature/presentation/widgets/routes_section.dart';
import 'package:axion/features/home_feature/presentation/widgets/start_cycling_buttom.dart';
import 'package:axion/features/home_feature/presentation/widgets/task_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axion/core/constants.dart';
import 'package:axion/features/home_feature/presentation/manger/home_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskBar(),
                    SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headerSection(),
                            SizedBox(height: screenHeight / 40),
                            AvgDistanceBox(),
                            SizedBox(height: 20),
                            RoutesSection(
                              routes: controller.routes,
                              onDeleteRoute: handleRouteDelete,
                            ),
                            SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                startCyclingButtom()
              ],
            )),
      ),
    );
  }
}
