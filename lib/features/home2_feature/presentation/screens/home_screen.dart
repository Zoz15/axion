import 'package:axion/features/home2_feature/data/delete_route.dart';
import 'package:axion/features/home2_feature/presentation/widgets/todaySummery.dart';
import 'package:axion/features/home2_feature/presentation/widgets/routes_section.dart';
import 'package:axion/features/home2_feature/presentation/widgets/start_cycling_buttom.dart';
import 'package:axion/features/home2_feature/presentation/widgets/background.dart';
import 'package:axion/features/home2_feature/presentation/widgets/topProfileHome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axion/core/constants.dart';
import 'package:axion/features/home2_feature/presentation/manger/home_controller.dart';

class HomeScreen2 extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopProfileHome(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight / 40),
                          TodaySummary(),
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
            ),
          ),
          startCyclingButtom()
        ],
      ),
    );
  }
}
