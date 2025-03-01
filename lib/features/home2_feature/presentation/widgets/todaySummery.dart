import 'package:axion/core/constants.dart';
import 'package:axion/features/home2_feature/presentation/manger/home_controller.dart';
import 'package:axion/features/home2_feature/presentation/widgets/my_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TodaySummary extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();

  TodaySummary({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Today\'s',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: lightColor),
            ),
            Text(
              '  Summary',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: orangeColor,
                  fontFamily: 'l'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            summaryContaner(
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SvgPicture.asset(
                        'assets/svg/fire.svg',
                        height: 60,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            '${homeController.cal.value} Cal',
                            style: TextStyle(
                              fontFamily: 'l',
                              fontSize: 20,
                              color: whiteColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          'Calories',
                          style: TextStyle(
                            fontSize: 10,
                            color: whiteColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            summaryContaner(
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SvgPicture.asset(
                        'assets/svg/locathion.svg',
                        height: 60,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            '${homeController.dist.value.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontFamily: 'l',
                              fontSize: 20,
                              color: whiteColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          'Distance',
                          style: TextStyle(
                            fontSize: 10,
                            color: whiteColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            summaryContaner(
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SvgPicture.asset(
                        'assets/svg/speed.svg',
                        height: 60,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            '${homeController.avg.value.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontFamily: 'l',
                              fontSize: 20,
                              color: whiteColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          'Avg speed',
                          style: TextStyle(
                            fontSize: 10,
                            color: whiteColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // Obx(() => Container(
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20),
        //         color: lightBlue,
        //       ),
        //       padding: EdgeInsets.all(15),
        //       width: screenWidth - 40,
        //       height: screenHeight / 4,
        //       // color: color,
        //       child: Column(
        //         children: [
        //           Expanded(
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment
        //                   .spaceBetween, // لضبط العناصر داخل المساحة المتاحة
        //               children: [
        //                 Column(
        //                   crossAxisAlignment:
        //                       CrossAxisAlignment.start, // محاذاة النصوص
        //                   children: [
        //                     Text(
        //                       'Avg speed',
        //                       style: GoogleFonts.poppins(
        //                         fontSize: 10,
        //                         color: const Color.fromARGB(255, 68, 68, 68),
        //                         fontWeight: FontWeight.w400,
        //                       ),
        //                     ),
        //                     Text(
        //                       '${homeController.avg.value.toStringAsFixed(1)} km/h',
        //                       style: GoogleFonts.poppins(
        //                         fontSize: 20,
        //                         color: Colors.black,
        //                         fontWeight: FontWeight.w800,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     Container(
        //                       height: 10,
        //                       width: 10,
        //                       decoration: BoxDecoration(
        //                         color: Colors.red,
        //                         shape: BoxShape.circle,
        //                       ),
        //                     ),
        //                     SizedBox(width: 10),
        //                     Container(
        //                       height: 10,
        //                       width: 10,
        //                       decoration: BoxDecoration(
        //                         color: Colors.blue,
        //                         shape: BoxShape.circle,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 Column(
        //                   crossAxisAlignment: CrossAxisAlignment.end,
        //                   children: [
        //                     Text(
        //                       'Distance',
        //                       style: GoogleFonts.poppins(
        //                         fontSize: 10,
        //                         color: const Color.fromARGB(255, 68, 68, 68),
        //                         fontWeight: FontWeight.w400,
        //                       ),
        //                     ),
        //                     Text(
        //                       '${homeController.dist.value.toStringAsFixed(1)} km',
        //                       style: GoogleFonts.poppins(
        //                         fontSize: 20,
        //                         color: Colors.black,
        //                         fontWeight: FontWeight.w800,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //           SizedBox(height: 10),
        //           Expanded(
        //             child: homeController.allAvg.length >= 2 &&
        //                     homeController.allDistanse.length >= 2
        //                 ? myLineChart(homeController)
        //                 : Center(
        //                     child: Text(
        //                       'No data to show \n Need at least 2 routes to see your stats',
        //                       style: GoogleFonts.poppins(color: Colors.black),
        //                       textAlign: TextAlign.center,
        //                     ),
        //                   ),
        //           ),
        //         ],
        //       ),
        //     )),
      ],
    );
  }

  Expanded summaryContaner(child) {
    return Expanded(
      child: Container(
        // margin: EdgeInsets.all(10),
        height: 130,
        decoration: BoxDecoration(
            color: Color(0xff141515), borderRadius: BorderRadius.circular(20)),
        child: Padding(padding: EdgeInsets.all(0), child: child),
      ),
    );
  }
}

// import 'package:axion/core/constants.dart';
// import 'package:axion/features/home2_feature/presentation/manger/home_controller.dart';
// import 'package:axion/features/home2_feature/presentation/widgets/my_line_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TodaySummary extends StatelessWidget {
//   final HomeController homeController = Get.find<HomeController>();

//   TodaySummary({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: lightBlue,
//           ),
//           padding: EdgeInsets.all(15),
//           width: screenWidth - 40,
//           height: screenHeight / 4,
//           // color: color,
//           child: Column(
//             children: [
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment
//                       .spaceBetween, // لضبط العناصر داخل المساحة المتاحة
//                   children: [
//                     Column(
//                       crossAxisAlignment:
//                           CrossAxisAlignment.start, // محاذاة النصوص
//                       children: [
//                         Text(
//                           'Avg speed',
//                           style: GoogleFonts.poppins(
//                             fontSize: 10,
//                             color: const Color.fromARGB(255, 68, 68, 68),
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         Text(
//                           '${homeController.avg.value.toStringAsFixed(1)} km/h',
//                           style: GoogleFonts.poppins(
//                             fontSize: 20,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           height: 10,
//                           width: 10,
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Container(
//                           height: 10,
//                           width: 10,
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           'Distance',
//                           style: GoogleFonts.poppins(
//                             fontSize: 10,
//                             color: const Color.fromARGB(255, 68, 68, 68),
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         Text(
//                           '${homeController.dist.value.toStringAsFixed(1)} km',
//                           style: GoogleFonts.poppins(
//                             fontSize: 20,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10),
//               Expanded(
//                 child: homeController.allAvg.length >= 2 &&
//                         homeController.allDistanse.length >= 2
//                     ? myLineChart(homeController)
//                     : Center(
//                         child: Text(
//                           'No data to show \n Need at least 2 routes to see your stats',
//                           style: GoogleFonts.poppins(color: Colors.black),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
