import 'dart:async';
import 'dart:math';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
// import 'package:background_location/background_location.dart';

class MyMapController extends GetxController with GetTickerProviderStateMixin {
  late final AnimatedMapController mapController;

  // RxString theMapUrl =
  //     'http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'.obs;
  // RxBool isMapSelectedOpen = false.obs;

  var isBatterySaveMode = false.obs;

  var roadPoints = <LatLng>[].obs;
  var currentPosition = Rx<LatLng?>(null);
  var speeds = <double>[].obs;
  var avg = 0.0.obs;
  loc.Location location = loc.Location();

  var currentZoom = 17.0.obs;
  var isFollowingUser = true.obs;

  Rx<double> totalDistance = 0.0.obs;
  var currentSpeed = 0.0.obs;
  var elapsedTime = ''.obs;

  LatLng? lastPosition;
  DateTime? lastTime;
  Timer? _timer;
  int _elapsedSeconds = 0;

  List<LatLng> recentPositions = [];

  @override
  void onInit() {
    super.onInit();
    //? background location 😊😊
    FlutterForegroundTask.init(
      
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_channel',
        channelName: 'Recording',
        channelDescription: 'Recording location in the background',
        priority: NotificationPriority.LOW,
        
        
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        autoRunOnBoot: true,
        allowWifiLock: true,
        eventAction: ForegroundTaskEventAction.repeat(
          AndroidPointerProperties.kToolTypeEraser,
        ),
      ),
    );
    // //? background location

    isInBatterySaveMode();

    location.changeSettings(
        accuracy: loc.LocationAccuracy.high, distanceFilter: 1, interval: 1000);

    mapController = AnimatedMapController(vsync: this);
    getLocation();
    startLocationUpdates();
    startTimer();
  }

  Future<void> isInBatterySaveMode() async {
    Battery battery = Battery();
    if (await battery.isInBatterySaveMode) isBatterySaveMode.value = true;
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    currentPosition.value = LatLng(position.latitude, position.longitude);
    roadPoints.add(LatLng(position.latitude, position.longitude));
  }

  void addPositionToHistory(LatLng position) {
    recentPositions.add(position);
    if (recentPositions.length > 5) {
      recentPositions.removeAt(0); // Keep only the last 5 positions
    }
  }

  Future<void> startLocationUpdates() async {
    
    location.onLocationChanged.listen(
      (loc.LocationData locationData) {
        if (locationData.latitude != null &&
            locationData.longitude != null &&
            locationData.accuracy! < 10) {
          //
          LatLng newPosition =
              LatLng(locationData.latitude!, locationData.longitude!);
          DateTime newTime = DateTime.now();

          if (lastPosition != null && lastTime != null) {
            double distance = Geolocator.distanceBetween(
              lastPosition!.latitude,
              lastPosition!.longitude,
              newPosition.latitude,
              newPosition.longitude,
            );

            double timeElapsed =
                newTime.difference(lastTime!).inSeconds.toDouble();
            if (timeElapsed > 0) {
              double calculatedSpeed =
                  (distance / timeElapsed) * 3.6; // Convert m/s to km/h

              speeds.add(calculatedSpeed); // Add the speed to the list
              avgSpeed(); // Calculate the average speed

              // Filter out unrealistic speed values
              if (calculatedSpeed <= 120) {
                totalDistance.value += distance;
                currentSpeed.value = calculatedSpeed;
              }
            }
          }

          // Update the last known position and time
          lastPosition = newPosition;
          lastTime = newTime;

          // Update the current position observable
          currentPosition.value = newPosition;

          // Add the position to the route
          roadPoints.add(newPosition);
        }
      },
    );
    //? background location   😊😊
    await FlutterForegroundTask.startService(
      notificationTitle: 'تتبع الموقع',
      notificationText: 'التطبيق يتتبع الموقع في الخلفية.',
      notificationIcon: NotificationIcon(metaDataName: 'ic_launcher'),
    );
    //? background location   😊😊
  }

  void avgSpeed() {
    double sum = 0;
    for (int i = 0; i < speeds.length; i++) {
      sum += speeds[i];
    }
    avg.value = sum / speeds.length;
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      elapsedTime.value = formatElapsedTime(_elapsedSeconds);
    });
  }

  String formatElapsedTime(int seconds) {
    final hours = (seconds ~/ 3600).toString();
    final minutes = ((seconds % 3600) ~/ 60).toString();
    final secs = (seconds % 60).toString();

    if (hours != '0') {
      return '$hours:${minutes.padLeft(2, '0')}:${secs.padLeft(2, '0')}';
    } else {
      return '$minutes:${secs.padLeft(2, '0')}';
    }
  }

  void toggleFollowingUser() {
    isFollowingUser.value = !isFollowingUser.value;
  }

  void moveToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    mapController.animateTo(
      dest: LatLng(position.latitude, position.longitude),
      zoom: currentZoom.value,
    );
  }

  void calculator() {
    // double totalDistance = 0.0;

    for (int i = 1; i < roadPoints.length; i++) {
      double lat1 = roadPoints[i - 1].latitude;
      double lon1 = roadPoints[i - 1].longitude;
      double lat2 = roadPoints[i].latitude;
      double lon2 = roadPoints[i].longitude;

      totalDistance += calculateDistance(lat1, lon1, lat2, lon2);
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371e3; // نصف قطر الأرض بالمتر
    double phi1 = lat1 * pi / 180;
    double phi2 = lat2 * pi / 180;
    double deltaPhi = (lat2 - lat1) * pi / 180;
    double deltaLambda = (lon2 - lon1) * pi / 180;

    double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // المسافة بالمتر
  }

  Future<void> resetRoute() async {
    //? background location   😊😊

    await FlutterForegroundTask.stopService();
    //? background location   😊😊

    roadPoints.clear();
    currentPosition.value = null;
    totalDistance.value = 0.0;
    currentSpeed.value = 0.0;
    elapsedTime.value = '';
    lastPosition = null;
    lastTime = null;
    _elapsedSeconds = 0;
    _timer?.cancel();
    currentPosition.value = null;
  }

  @override
  void onClose() {
    mapController.dispose();
    currentPosition.value = null;
    super.onClose();
  }
}
