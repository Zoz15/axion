import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride/Screens/map_Screen.dart';
import 'package:ride/Screens/map_Screen_Permission.dart';
import 'package:ride/var.dart';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ride/manger/home_controller.dart';

class HomeScreen extends StatelessWidget {
  // final SplashToHome controller = Get.put(SplashToHome());
  final HomeController homeController = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      // backgroundColor: Colors.white,
      body: Stack(
        children: [
          countant_home_screen(),

          // SplashWidget(),
          // _NavigationControls(),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class countant_home_screen extends StatelessWidget {
  final controller = Get.find<HomeController>();

  countant_home_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TaskBar(),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HeaderSection(),
                          SizedBox(height: screenHeight / 40),
                          _AvgDistanceBox(),
                          SizedBox(height: 20),
                          _RoutesSection(
                            routes: controller.routes,
                            onDeleteRoute: _handleRouteDelete,
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              StartCyclingButtom()
            ],
          )),
    );
  }

  Future<void> _handleRouteDelete(int index, Map<String, dynamic> route) async {
    await controller.deleteRoute(index, route);
  }
}

class StartCyclingButtom extends StatelessWidget {
  const StartCyclingButtom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () async {
            bool isLocation = await _chickLocation();
            if (isLocation == true) {
              Get.to(() => MapScreen());
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: pinkColor,
            ),
            height: 60,
            width: screenWidth * .6,
            // color: pinkColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Start Cycling',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(width: 10),
                Container(
                  height: 35,
                  width: 35,
                  padding: EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: darkColor),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      lightColor,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/images/icon_photo.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Hi data',
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: lightColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Let\'s cycle!',
          style: GoogleFonts.orbitron(
            fontSize: 40,
            color: lightColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AvgDistanceBox extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
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
                      child: homeController.allAvg.length > 2 &&
                              homeController.allDistanse.length > 2
                          ? myLineChart()
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
        // Obx(
        //   () => Avg_Distance(
        //     child: _buildStatColumn('Avg speed',
        //         '${homeController.avg.value.toStringAsFixed(1)} km/h',
        //         isWhite: true),
        //   ),
        // ),
        // Obx(
        //   () => Avg_Distance(
        //     color: lightBlue,
        //     child: _buildStatColumn('Distance',
        //         '${homeController.dist.value.toStringAsFixed(1)} km'),
        //   ),
        // ),
      ],
    );
  }

  Widget myLineChart() {
    return LineChart(
      LineChartData(
          lineBarsData: [
            LineChartBarData(
              show: true,
              spots: homeController.allAvg
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              color: Colors.red,
              isCurved: true,
              barWidth: 6,
              curveSmoothness: 0.3,
              isStrokeCapRound: true,
            ),
            LineChartBarData(
              show: true,
              spots: homeController.allDistanse
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              color: Colors.blue,
              isCurved: true,
              barWidth: 6,
              curveSmoothness: 0.3,
              isStrokeCapRound: true,
            ),
          ],
          titlesData: FlTitlesData(
            show: false,
          ),
          gridData: FlGridData(
            show: false,
          ),
          borderData: FlBorderData(
            show: false,
          )),
    );
  }
}

class _RoutesSection extends StatelessWidget {
  final RxList<Map<String, dynamic>> routes;
  final Function(int, Map<String, dynamic>) onDeleteRoute;

  const _RoutesSection({
    required this.routes,
    required this.onDeleteRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Routes',
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w600, color: lightColor),
        ),
        SizedBox(height: 10),

        Obx(() {
          return routes.isEmpty
              ? SizedBox(
                  height: screenHeight / 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No routes saved yet',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            bool isLocation = await _chickLocation();
                            if (isLocation == true) {
                              Get.to(() => MapScreen());
                            }
                          },
                          child: Text(
                            'Start cycling',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Color(0xff00A6ED),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: routes.length,
                  itemBuilder: (context, index) {
                    final route = routes[index];
                    return _RouteCard(
                      route: route,
                      onDelete: () => onDeleteRoute(index, route),
                    );
                  },
                );
        }),

        // Obx(
        //   () => ,
        // ),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  final Map<String, dynamic> route;
  final VoidCallback onDelete;

  const _RouteCard({
    required this.route,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(route['timestamp']),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _showDeleteConfirmation(context),
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: _buildRouteContent(),
    );
  }

  Widget _buildRouteContent() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRouteHeader(),
            SizedBox(height: 15),
            _buildRouteStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          route['name'],
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              route['elapsedTime'],
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            Text(
              _formatTimestamp(DateTime.parse(route['timestamp'])),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem(
          icon: Icons.speed,
          value: '${route['averageSpeed'].toStringAsFixed(1)}',
          unit: 'km/h',
          label: 'Avg Speed',
        ),
        _buildStatItem(
          icon: Icons.straighten,
          value: '${route['totalDistance'].toStringAsFixed(2)}',
          unit: 'km',
          label: 'Distance',
        ),
        if (route['details']?.isNotEmpty ?? false)
          _buildStatItem(
            icon: Icons.description,
            value: route['details'],
            label: 'Notes',
            isNote: true,
          ),
      ],
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: darkColor,
          title: Text('Delete Route?',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, color: lightColor)),
          content: Text('Are you sure you want to delete this route?',
              style: GoogleFonts.poppins(color: lightColor)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: GoogleFonts.poppins(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child:
                  Text('Delete', style: GoogleFonts.poppins(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildStatItem({
  required IconData icon,
  required String value,
  String? unit,
  required String label,
  bool isNote = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[400]),
          SizedBox(width: 4),
          Text(
            isNote ? '${value.substring(0, min(value.length, 10))}...' : value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (unit != null)
            Text(
              ' $unit',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
        ],
      ),
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[400],
        ),
      ),
    ],
  );
}

String _formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays == 0) {
    if (difference.inHours == 0) {
      if (difference.inMinutes == 0) {
        return 'Just now';
      }
      return '${difference.inMinutes}m ago';
    }
    return '${difference.inHours}h ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

class _TaskBar extends StatelessWidget {
  const _TaskBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: EdgeInsets.all(20),
      height: screenHeight / 20,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.location_on),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color.fromARGB(255, 226, 223, 223),
            ),
            height: screenHeight / 10,
            //width: screenWidth / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //todo: add coins
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('data'),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    'https://i.pinimg.com/736x/11/4b/19/114b19b343986be2290b2ff722383552.jpg',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<void> deleteRideFromStorage(String rideId) async {
  final prefs = await SharedPreferences.getInstance();
  // Get existing rides
  final ridesJson = prefs.getStringList('rides') ?? [];
  // Remove the ride with matching ID
  ridesJson.removeWhere((rideStr) {
    final ride = json.decode(rideStr);
    return ride['id'] == rideId;
  });
  // Save updated list back to storage
  await prefs.setStringList('rides', ridesJson);
}

Future<bool> _chickLocation() async {
  print(
      'isLocationServiceEnabled: ${await Geolocator.isLocationServiceEnabled()}');
  print('checkPermission: ${await Geolocator.checkPermission()}');
  print('checkPermission: ${await Geolocator.checkPermission()}');

  if (await Geolocator.isLocationServiceEnabled() == false ||
      await Geolocator.checkPermission() == LocationPermission.denied ||
      await Geolocator.checkPermission() == LocationPermission.deniedForever) {
    Get.to(() => MapScreenPermission());
    return false;
  } else {
    return true;
  }
}
