import 'package:axion/features/map_feature/presentation/widgets/chack.dart';
import 'package:axion/features/save_rode_feature/presentation/screen/save_rode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:axion/features/map_feature/presentation/manger/map_controller.dart';
import 'package:axion/core/constants.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  final controller = Get.put(MyMapController());
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Obx(() {
        return Stack(
          children: [
            MapView(),
            controller.isStart.value ? _Counter() : _startButton(),
            controller.isInBigCounter.value ? bigCounter() : SizedBox(),
            MapAssets(),
            controller.isBatterySaveMode.value ? isInSaveMood() : SizedBox(),
          ],
        );
      })),
    );
  }

  Widget bigCounter() {
    return Container(
      height: screenHeight,
      width: screenWidth,
      color: blackColor,
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: SafeArea(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              Text(
                controller.elapsedTime.value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontFamily: 'l',
                  // fontWeight: FontWeight.w400,
                  // letterSpacing: 0.24,
                ),
              ),
              Container(
                height: 1,
                width: screenWidth,
                color: Colors.grey[800],
              ),
              Text(
                'Avg Speed',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              Text(
                controller.avg.value.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 120,
                  fontFamily: 'l',
                  // fontWeight: FontWeight.w400,
                  // letterSpacing: 0.24,
                ),
              ),
              Text(
                'KM/H',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              Container(
                height: 1,
                width: screenWidth,
                color: Colors.grey[800],
              ),
              Text(
                'Distance',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              Text(
                controller.totalDistance.value.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontFamily: 'l',
                  // fontWeight: FontWeight.w400,
                  // letterSpacing: 0.24,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => controller.toggleRide(),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: blackColor,
                        border: Border.all(color: grayColor, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: controller.isPaused.value
                              ? SvgPicture.asset(
                                  'assets/svg/start.svg',
                                  height: 25,
                                )
                              : SvgPicture.asset(
                                  'assets/svg/pause.svg',
                                )),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => stopCycling(),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: orangeColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg/stop.svg',
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _startButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: screenWidth,
        height: 130,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        // clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: grayColor, width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                // controller.isRideing.value = true;
                controller.isStart.value = true;
                // controller.toggleRide();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  color: grayColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 30,
                        height: 30,
                        child: SvgPicture.asset('assets/svg/start.svg')),
                    const SizedBox(width: 16),
                    Text(
                      'Start Axion',
                      style: TextStyle(
                        color: Color(0xFFF7F7F7),
                        fontSize: 24,
                        fontFamily: 'l',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget MapAssets() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.isInBigCounter.value == false
                ? GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                        radius: 20,
                        titleStyle: const TextStyle(fontSize: 1, height: 0),
                        title: '',
                        // middleText:
                        //     'Axion needs a longer activity to detect a route. Please try to move to record a route.',
                        backgroundColor: blackColor,
                        content: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Are you sure ?',
                                      style: TextStyle(fontSize: 25)),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Are you sure you want to discard the route?',
                              ),
                              SizedBox(height: 25),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.resetRoute();
                                        Get.back();
                                        Get.offNamed('/home');
                                        // Get.back();
                                      },
                                      child: Container(
                                        // padding: const EdgeInsets.all(5),
                                        height: 50,
                                        // width: 50,
                                        decoration: BoxDecoration(
                                          // color: orangeColor,
                                          border: Border.all(
                                              color: orangeColor, width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/chickMark.svg',
                                              color: orangeColor,
                                            ),
                                            const SizedBox(width: 5),
                                            Text('Sure',
                                                style: TextStyle(
                                                    color: orangeColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () => Get.back(),
                                      child: Container(
                                        // padding: const EdgeInsets.all(15),
                                        height: 50,
                                        // width: 50,
                                        decoration: BoxDecoration(
                                          color: orangeColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/discard.svg',
                                              // height: 22,
                                              color: blackColor,
                                            ),
                                            const SizedBox(width: 5),
                                            Text('Cancel',
                                                style: TextStyle(
                                                    color: blackColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: darkColor,
                        border: Border.all(color: grayColor, width: 1),
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/exit.svg',
                      ),
                    ),
                  )
                : SizedBox(),
            Obx(() {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.isInBigCounter.value =
                          !controller.isInBigCounter.value;
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: darkColor,
                        border: Border.all(color: grayColor, width: 1),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: orangeColor,
                      ),
                    ),
                  ),
                  if (controller.isInBigCounter.value == false)
                    SizedBox(height: 20),
                  if (controller.isInBigCounter.value == false)
                    GestureDetector(
                      onTap: () {
                        controller.isFollowingUser.value = true;
                        controller.moveToCurrentLocation();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: darkColor,
                          border: Border.all(color: grayColor, width: 1),
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/gps.svg',
                        ),
                      ),
                    ),
                ],
              );
            })

            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final controller = Get.find<MyMapController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return FlutterMap(
          mapController: controller.mapController.mapController,
          options: MapOptions(
            backgroundColor: grayColor,
            initialCenter: controller.currentPosition.value,
            initialZoom: 17.0,
            onMapEvent: (event) {
              if (event.source == MapEventSource.onDrag) {
                controller.currentZoom.value = event.camera.zoom;
                controller.isFollowingUser.value = false;
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: theMapUrl,
              subdomains: ['a', 'b', 'c', 'd'], // قائمة نطاقات الخادم
              // subdomains: ['a', 'b', 'c'], // قائمة نطاقات الخادم
            ),
            // PolylineLayer(
            //   polylines: [
            //     Polyline(
            //       points: controller.roadPoints,
            //       strokeWidth: 5,
            //       color: orangeColor,
            //     ),
            //   ],
            // ),

            PolylineLayer(
              polylines:
                  List.generate(controller.recordedPoints.length, (index) {
                return Polyline(
                  points: controller.recordedPoints[index],
                  strokeWidth: 5,
                  color: controller.roadColors[index], // لون كل جزء حسب حالته
                );
              }),
            ),

            LocationMarkerLayer(),
          ],
        );
      },
    );
  }
}

class LocationMarkerLayer extends StatefulWidget {
  @override
  _LocationMarkerLayerState createState() => _LocationMarkerLayerState();
}

class _LocationMarkerLayerState extends State<LocationMarkerLayer>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<MyMapController>();

  LatLng lastLocation = LatLng(0, 0);
  LatLng newLocation = LatLng(0, 0);

  late AnimationController _animationController;
  late Animation<LatLng> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = LatLngTween(
      begin: lastLocation,
      end: newLocation,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var position = controller.currentPosition.value;
      lastLocation = newLocation;
      newLocation = position!;
      _animation = LatLngTween(
        begin: lastLocation,
        end: newLocation,
      ).animate(_animationController);
      _animationController.reset();
      _animationController.forward();

      if (controller.isFollowingUser.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.mapController.animateTo(
            dest: newLocation,
            zoom: controller.currentZoom.value,
          );
        });
      }
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return AnimatedMarkerLayer(
            markers: [
              AnimatedMarker(
                width: 20.0,
                height: 20.0,
                point: _animation.value,
                builder: (_, animation) {
                  return Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: orangeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    });
  }
}

class _Counter extends GetView<MyMapController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Positioned(
        bottom: controller.counterPosition.value,

        // alignment: Alignment.bottomCenter,
        child: Container(
          // duration: Duration(milliseconds: 1000),
          height: screenHeight / 2.7,
          decoration: BoxDecoration(
            border: Border.all(color: grayColor, width: 2),
            color: blackColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultRadius),
                topRight: Radius.circular(defaultRadius)),
          ),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
                color: blackColor,
                // border: Border.all(color: grayColor, ?width: 2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(defaultRadius),
                  topRight: Radius.circular(defaultRadius),
                )),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      controller.updatePosition(-details.primaryDelta!);
                    },
                    onVerticalDragEnd: (details) {
                      controller.handleDragEnd();
                    },
                    child: Container(
                      color: blackColor,
                      width: screenWidth - 20,
                      height: 15,
                      child: Center(
                        child: Container(
                          height: 4,
                          width: screenWidth * .4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.toggleRide();
                        },
                        child: Container(
                          width: screenWidth / 2 - 30,
                          height: screenHeight / 13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: grayColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              controller.isPaused.value == false
                                  ? SvgPicture.asset('assets/svg/pause.svg')
                                  : SvgPicture.asset('assets/svg/start.svg'),
                              SizedBox(width: 10),
                              Text(
                                controller.isPaused.value == true
                                    ? 'Start'
                                    : 'Pause',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          stopCycling();
                        },
                        child: Container(
                          width: screenWidth / 2 - 30,
                          height: screenHeight / 13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: grayColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/svg/stop.svg'),
                              SizedBox(width: 10),
                              Text(
                                'Stop',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    controller.elapsedTime.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontFamily: 'l',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.24,
                    ),
                  ),
                  Text(
                    'Duration',
                    style: TextStyle(
                      color: orangeColor,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.shade900,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              controller.totalDistance.value < 10
                                  ? Text(
                                      (controller.totalDistance.value)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    )
                                  : Text(
                                      (controller.totalDistance.value)
                                          .toStringAsFixed(0),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                              Text(
                                ' Km',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          Text(
                            'Distance',
                            style: TextStyle(
                              color: orangeColor,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey.shade900,
                      ),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                controller.currentSpeed.value
                                    .toStringAsFixed(1),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              Text(
                                ' Km/h',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          Text(
                            'Speed',
                            style: TextStyle(
                              color: orangeColor,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey.shade900,
                      ),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            // mainAxisAlignment: MainAxisAlignment.end,
                            // mainAxisAlignment: MainAxisAlignment,
                            children: [
                              Text(
                                controller.avg.value.toStringAsFixed(1),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              Text(
                                ' Avg',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          Text(
                            'Avg',
                            style: TextStyle(
                              color: orangeColor,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

void stopCycling() {
  final controller = Get.find<MyMapController>();
  // controller.toggleRide(); // Stop recording first

  if (controller.totalDistance.value < 1) {
    Get.defaultDialog(
      radius: 20,
      titleStyle: const TextStyle(fontSize: 1, height: 0),
      title: '',
      // middleText:
      //     'Axion needs a longer activity to detect a route. Please try to move to record a route.',
      backgroundColor: blackColor,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text('Not moving yet ?', style: TextStyle(fontSize: 25)),
                Spacer(),
              ],
            ),
            SizedBox(height: 15),
            Text(
              'Axion needs a longer activity to detect a route. Please try to move to record a route.',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'need at lest 1KM',
                  style: TextStyle(
                    color: orangeColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              // mainAxisAlignment: MainAxisAlignment.,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      controller.resetRoute();
                      Get.back();
                      Get.offNamed('/home');
                      // Get.back();
                    },
                    child: Container(
                      // padding: const EdgeInsets.all(5),
                      height: 50,
                      // width: 50,
                      decoration: BoxDecoration(
                        // color: orangeColor,
                        border: Border.all(color: orangeColor, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svg/discard.svg'),
                          const SizedBox(width: 5),
                          Text('Discard', style: TextStyle(color: orangeColor)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      // padding: const EdgeInsets.all(15),
                      height: 50,
                      // width: 50,
                      decoration: BoxDecoration(
                        color: orangeColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/start.svg',
                            height: 22,
                            color: blackColor,
                          ),
                          const SizedBox(width: 5),
                          Text('Resume', style: TextStyle(color: blackColor)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return;
  }

  Get.to(() => SaveRouteScreen(
        recordedPoints: controller.recordedPoints,
        totalDistance: controller.totalDistance.value,
        elapsedTime: controller.elapsedTime.value,
        roadColors: controller.roadColors.value,
        speeds: controller.speeds.value,
        // averageSpeed: controller.avg.value,
      ));
}

Stream<void> createAlignDirectionStream() {
  return Stream.periodic(Duration(milliseconds: 500), (count) {
    // Emit an event every 500ms (0.5 seconds)
    return;
  });
}




//!------------------------------


// import 'package:axion/features/map_feature/presentation/widgets/chack.dart';
// import 'package:axion/features/save_rode_feature/presentation/screen/save_rode_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_animations/flutter_map_animations.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:axion/features/map_feature/presentation/manger/map_controller.dart';
// import 'package:axion/core/constants.dart';

// class MapScreen extends StatelessWidget {
//   final controller = Get.put(MyMapController());

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       controller.getLocation();
//     });
//     return Obx(() {            
//       if (controller.currentPosition.value == null) {
//         return Center(
//             child: CircularProgressIndicator(
//           color: pinkColor,
//         ));
//       } else {
//         return MaterialApp(
//           home: Scaffold(
//             body: Stack(
//               children: [
//                 MapView(),
//                 _Counter(),
//                 // _chouseMap(),
//                 Obx(
//                   () => controller.isBatterySaveMode.value
//                       ? isInSaveMood()
//                       : SizedBox(),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//     });
//     // Scaffold(
//     //   backgroundColor: Color(0xFF162130),
//     //   body:
//   }
// }

// class MapView extends StatefulWidget {
//   @override
//   State<MapView> createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   final controller = Get.find<MyMapController>();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () {
//         if (controller.currentPosition.value == null) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           return FlutterMap(
//             mapController: controller.mapController.mapController,
//             options: MapOptions(
//               backgroundColor: darkColor,
//               initialCenter: controller.currentPosition.value!,
//               initialZoom: 17.0,
//               onMapEvent: (event) {
//                 if (event.source == MapEventSource.onDrag) {
//                   controller.currentZoom.value = event.camera.zoom;
//                   controller.isFollowingUser.value = false;
//                 }
//               },
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: theMapUrl,
//                 subdomains: ['a', 'b', 'c', 'd'], // قائمة نطاقات الخادم
//               ),
//               PolylineLayer(
//                 polylines: [
//                   Polyline(
//                     points: controller.roadPoints,
//                     strokeWidth: 5,
//                     color: pinkColor,
//                   ),
//                 ],
//               ),
              
//               LocationMarkerLayer(),
//             ],
//           );
//         }
//       },
//     );
//   }
// }

// class LocationMarkerLayer extends StatefulWidget {
//   @override
//   _LocationMarkerLayerState createState() => _LocationMarkerLayerState();
// }

// class _LocationMarkerLayerState extends State<LocationMarkerLayer>
//     with SingleTickerProviderStateMixin {
//   final controller = Get.find<MyMapController>();

//   LatLng lastLocation = LatLng(0, 0);
//   LatLng newLocation = LatLng(0, 0);

//   late AnimationController _animationController;
//   late Animation<LatLng> _animation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _animation = LatLngTween(
//       begin: lastLocation,
//       end: newLocation,
//     ).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//     final position = controller.currentPosition.value;
//     lastLocation = newLocation;
//     // }
//     newLocation = position!;
//     // isGetFirstLocation = true;

//     // تحريك الموقع بشكل سلس
//     _animation = LatLngTween(
//       begin: lastLocation,
//       end: newLocation,
//     ).animate(_animationController);

//     _animationController.reset();
//     _animationController.forward();

//     if (controller.isFollowingUser.value) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         controller.mapController.animateTo(
//           dest: newLocation,
//           zoom: controller.currentZoom.value,
//         );
//       });
//     }
//       return AnimatedBuilder(
//         animation: _animation,
//         builder: (context, child) {
//           return AnimatedMarkerLayer(
//             markers: [
//               AnimatedMarker(
//                 width: 20.0,
//                 height: 20.0,
//                 point: _animation.value,
//                 builder: (_, animation) {
//                   return Container(
//                     padding: EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.pink,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     });
//   }
// }

// class _Counter extends GetView<MyMapController> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           Spacer(),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: Container(
//                 padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: lightOfDarkColor,
//                   border: Border.all(color: pinkColor, width: 2),
//                 ),
//                 width: screenWidth - 40,
//                 child: Column(
//                   children: [
//                     Obx(() => Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Column(
//                               children: [
//                                 Text(
//                                     controller.totalDistance.value > 9
//                                         ? (controller.totalDistance.value /
//                                                 1000)
//                                             .toStringAsFixed(2)
//                                         : (controller.totalDistance.value /
//                                                 1000)
//                                             .toStringAsFixed(1),
//                                     style: textStyle),
//                                 Text('KM', style: textStyle2),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 Text(controller.elapsedTime.value.toString(),
//                                     style: textStyle),
//                                 Text('TIME', style: textStyle2),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 Text(controller.avg.value.toStringAsFixed(1),
//                                     style: textStyle),
//                                 Text('AVG', style: textStyle2),
//                               ],
//                             ),
//                           ],
//                         )),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             controller.isFollowingUser.value = true;
//                             controller.moveToCurrentLocation();
//                           },
//                           child: Container(
//                               width: screenWidth / 4 - 40,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   color: pinkColor),
//                               child: Obx(
//                                 () => Icon(
//                                   controller.isFollowingUser.value
//                                       ? Icons.gps_fixed
//                                       : Icons.gps_not_fixed,
//                                   color: Colors.white,
//                                 ),
//                               )),
//                         ),
//                         SizedBox(width: 10),
//                         InkWell(
//                           onTap: stopCycling,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: pinkColor,
//                             ),
//                             width: (screenWidth / 4 * 3) - 40,
//                             height: 50,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Stop cycling',
//                                   style: GoogleFonts.cairo(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w800,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 8.0),
//                                   child: Container(
//                                     height: 50,
//                                     width: 50,
//                                     padding: EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: darkColor,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: ColorFiltered(
//                                       colorFilter: const ColorFilter.mode(
//                                         Colors.white,
//                                         BlendMode.srcIn,
//                                       ),
//                                       child: Image.asset(
//                                         'assets/images/icon_photo.png',
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void stopCycling() {
//     // controller.toggleRecording(); // Stop recording first

//     Get.to(() => SaveRouteScreen(
//           recordedPoints: controller.roadPoints,
//           totalDistance: controller.totalDistance.value / 1000,
//           elapsedTime: controller.elapsedTime.value,
//           averageSpeed: controller.avg.value,
//         ));
//   }

//   static TextStyle textStyle = GoogleFonts.cairo(
//       fontSize: 35, fontWeight: FontWeight.bold, color: lightColor);

//   static TextStyle textStyle2 =
//       GoogleFonts.orbitron(fontSize: 15, color: Colors.white);
// }

// Stream<void> createAlignDirectionStream() {
//   return Stream.periodic(Duration(milliseconds: 500), (count) {
//     // Emit an event every 500ms (0.5 seconds)
//     return;
//   });
// }
