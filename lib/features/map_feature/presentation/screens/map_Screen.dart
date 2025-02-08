// import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:axion/features/map_feature/presentation/widgets/chack.dart';
import 'package:axion/features/save_rode_feature/presentation/screen/save_rode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:axion/features/map_feature/presentation/manger/map_controller.dart';
import 'package:axion/core/constants.dart';

class MapScreen extends StatelessWidget {
  final controller = Get.put(MyMapController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.getLocation();
    });
    return Obx(() {
      if (controller.currentPosition.value == null) {
        return Center(
            child: CircularProgressIndicator(
          color: pinkColor,
        ));
      } else {
        return MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                MapView(),
                _Counter(),
                // _chouseMap(),
                Obx(
                  () => controller.isBatterySaveMode.value
                      ? isInSaveMood()
                      : SizedBox(),
                ),
              ],
            ),
          ),
        );
      }
    });
    // Scaffold(
    //   backgroundColor: Color(0xFF162130),
    //   body:
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
        if (controller.currentPosition.value == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return FlutterMap(
            mapController: controller.mapController.mapController,
            options: MapOptions(
              backgroundColor: darkColor,
              initialCenter: controller.currentPosition.value!,
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
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: controller.roadPoints,
                    strokeWidth: 5,
                    color: pinkColor,
                  ),
                ],
              ),
              // CurrentLocationLayer(
              //   alignDirectionStream: controller.alignDirectionStream,
              //   style: LocationMarkerStyle(
              //     accuracyCircleColor: pinkColor,
              //     headingSectorColor: pinkColor,
              //     marker: DefaultLocationMarker(
              //       color: pinkColor,
              //     ),
              //   ),
              //   alignDirectionAnimationCurve: Curves.bounceInOut,
              // ),
              LocationMarkerLayer(),
            ],
          );
        }
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
  bool isGetFirstLocation = false;

  late AnimationController _animationController;
  late Animation<LatLng> _animation;

  @override
  void initState() {
    super.initState();

    // إعداد AnimationController
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000), // Adjusted to 1 second
      vsync: this,
    );

    // تهيئة Animation من نوع Tween
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
    return StreamBuilder<LocationData>(
      stream: controller.location.onLocationChanged,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return isGetFirstLocation == false
              ? AnimatedMarkerLayer(
                  markers: [
                    AnimatedMarker(
                      width: 20.0,
                      height: 20.0,
                      point: controller.currentPosition.value!,
                      builder: (_, animation) {
                        return Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: pinkColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              : const SizedBox();
        }

        // تحديث المواقع
        if (isGetFirstLocation) {
          lastLocation = newLocation;
        }
        newLocation = LatLng(
          snapshot.data!.latitude!,
          snapshot.data!.longitude!,
        );
        isGetFirstLocation = true;

        // تحديث التحريك بين الموقعين
        _animation = LatLngTween(
          begin: lastLocation,
          end: newLocation,
        ).animate(_animationController);

        // بدء التحريك
        _animationController.reset();
        _animationController.forward();

        if (controller.isFollowingUser.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print('Moving to new location: $newLocation');
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
                          color: pinkColor,
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
      },
    );
  }
}

class _Counter extends GetView<MyMapController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: lightOfDarkColor,
                  border: Border.all(color: pinkColor, width: 2),
                ),
                width: screenWidth - 40,
                child: Column(
                  children: [
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                    controller.totalDistance.value > 9
                                        ? (controller.totalDistance.value /
                                                1000)
                                            .toStringAsFixed(2)
                                        : (controller.totalDistance.value /
                                                1000)
                                            .toStringAsFixed(1),
                                    style: textStyle),
                                Text('KM', style: textStyle2),
                              ],
                            ),
                            Column(
                              children: [
                                Text(controller.elapsedTime.value,
                                    style: textStyle),
                                Text('TIME', style: textStyle2),
                              ],
                            ),
                            Column(
                              children: [
                                Text(controller.avg.value.toStringAsFixed(1),
                                    style: textStyle),
                                Text('AVG', style: textStyle2),
                              ],
                            ),
                          ],
                        )),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.isFollowingUser.value = true;
                            controller.moveToCurrentLocation();
                          },
                          child: Container(
                              width: screenWidth / 4 - 40,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: pinkColor),
                              child: Obx(
                                () => Icon(
                                  controller.isFollowingUser.value
                                      ? Icons.gps_fixed
                                      : Icons.gps_not_fixed,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: stopCycling,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: pinkColor,
                            ),
                            width: (screenWidth / 4 * 3) - 40,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Stop cycling',
                                  style: GoogleFonts.cairo(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: darkColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      child: Image.asset(
                                        'assets/images/icon_photo.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void stopCycling() {
    // controller.toggleRecording(); // Stop recording first

    Get.to(() => SaveRouteScreen(
          recordedPoints: controller.roadPoints,
          totalDistance: controller.totalDistance.value / 1000,
          elapsedTime: controller.elapsedTime.value,
          averageSpeed: controller.avg.value,
        ));
  }

  static TextStyle textStyle = GoogleFonts.cairo(
      fontSize: 35, fontWeight: FontWeight.bold, color: lightColor);

  static TextStyle textStyle2 =
      GoogleFonts.orbitron(fontSize: 15, color: Colors.white);
}

Stream<void> createAlignDirectionStream() {
  return Stream.periodic(Duration(milliseconds: 500), (count) {
    // Emit an event every 500ms (0.5 seconds)
    return;
  });
}
