// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ride/manger/splash_to_home.dart';
// import 'package:ride/var.dart';

// class StartCycling extends StatelessWidget {
//   const StartCycling({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: SizedBox(
//         height: 50,
//         child: Stack(
//           children: [
//             Align(alignment: Alignment.centerLeft, child: PageIndicator()),
//             Align(alignment: Alignment.centerRight, child: NavigationButton()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NavigationButton extends GetView<SplashToHome> {
//   const NavigationButton();

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: _handleNavigation,
//       child: Obx(() => AnimatedContainer(
//             duration: const Duration(milliseconds: 1000),
//             curve: Curves.easeInOutCubic,
//             width: controller.isSplashAnimathionFull.value
//                 ? 80
//                 : controller.page.value == 2
//                     ? screenWidth - 60
//                     : screenWidth - 40,
//             height: 50,
//             decoration: _buildButtonDecoration(),
//             child: Center(
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 1000),
//                 child: controller.isSplashAnimathionFull.value
//                     ? Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Image.asset(
//                           'assets/images/icon_photo.png',
//                         ),
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Flexible(
//                             child: AnimatedSwitcher(
//                               duration: const Duration(milliseconds: 300),
//                               transitionBuilder:
//                                   (Widget child, Animation<double> animation) {
//                                 return FadeTransition(
//                                   opacity: animation,
//                                   child: child,
//                                 );
//                               },
//                               child: Text(
//                                 'Start cycling',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 15,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           ColorFiltered(
//                             colorFilter: const ColorFilter.mode(
//                               Colors.white,
//                               BlendMode.srcIn,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Image.asset(
//                                 'assets/images/icon_photo.png',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//             ),
//           )),
//     );
//   }

//   void _handleNavigation() {
//     // TODO: Check if the user is logged in
//     // If logged in -> navigate to home page
//     // If not logged in -> navigate to login page
//     controller.Botton_taped();
//   }

//   BoxDecoration _buildButtonDecoration() {
//     return controller.isSplashAnimathionFull.value
//         ? BoxDecoration(
//             borderRadius: BorderRadius.circular(100),
//             color: Colors.white,
//           )
//         : BoxDecoration(
//             borderRadius: BorderRadius.circular(0),
//             color: Colors.black,
//           );
//   }
// }

// class PageIndicator extends GetView<SplashToHome> {
//   const PageIndicator();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => AnimatedOpacity(
//           opacity: controller.isSplashAnimathionFull.value ? 1.0 : 0.0,
//           duration: const Duration(milliseconds: 800),
//           curve: Curves.easeInCubic,
//           child: Container(
//             height: 5,
//             width: 60,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(100),
//               color: const Color.fromARGB(255, 110, 110, 110),
//             ),
//             child: _buildIndicatorDot(),
//           ),
//         ));
//   }

//   Widget _buildIndicatorDot() {
//     return Obx(() => AnimatedAlign(
//           alignment: controller.page.value == 0
//               ? Alignment.centerLeft
//               : Alignment.centerRight,
//           curve: Curves.easeInOut,
//           duration: const Duration(milliseconds: 300),
//           child: Container(
//             height: 5,
//             width: 30,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(100),
//               color: Colors.white,
//             ),
//           ),
//         ));
//   }
// }
