import 'package:axion/core/constants.dart';
import 'package:axion/features/home_feature/presentation/manger/home_controller.dart';
import 'package:axion/features/home_feature/presentation/widgets/my_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AvgDistanceBox extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();

   AvgDistanceBox({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => Expanded(
              // flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: lightBlue,
                ),
                padding: EdgeInsets.all(15),
                width: screenWidth - 40,
                height: screenHeight / 4,
                // color: color,
                child: Column(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Avg speed',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: const Color.fromARGB(255, 68, 68, 68),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${homeController.avg.value.toStringAsFixed(1)} km/h',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(100),
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(100),
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              'Distance',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: const Color.fromARGB(255, 68, 68, 68),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${homeController.dist.value.toStringAsFixed(1)} km',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: homeController.allAvg.length >= 2 &&
                              homeController.allDistanse.length >= 2
                          ? myLineChart(homeController)
                          : Center(
                              child: Text(
                                'No data to show \n Need at least 2 routes to see your stats',
                                style: GoogleFonts.poppins(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            )),

      ],
    );
  }
}
