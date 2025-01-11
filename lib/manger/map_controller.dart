import 'dart:async';
import 'dart:math';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';

class MyMapController extends GetxController with GetTickerProviderStateMixin {
  late final AnimatedMapController mapController;

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

    location.changeSettings(
        accuracy: loc.LocationAccuracy.high, distanceFilter: 1, interval: 1000);

    mapController = AnimatedMapController(vsync: this);
    getLocation();
    startLocationUpdates();
    startTimer();
  }

  Future<void> getLocation() async {
    bool permission = await checkPermission();
    try {
      if (permission) {
        Position position = await Geolocator.getCurrentPosition();
        currentPosition.value = LatLng(position.latitude, position.longitude);
      } else {
        Get.snackbar('Error', 'Location permission denied');
      }
    } catch (e) {
      print('Error is $e');
    }
  }

  Future<bool> checkPermission() async {
    // التحقق من تفعيل خدمات الموقع
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Get.snackbar(
            'Error', 'Location services are disabled. Please enable them.');
        return false;
      }
    }

    // التحقق من الأذونات
    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        Get.snackbar('Error', 'Location permission denied. Please allow it.');
        return false;
      }
    }

    // معالجة حالة deniedForever
    if (permissionGranted == loc.PermissionStatus.deniedForever) {
      Get.snackbar(
        'Error',
        'Location permission is permanently denied. Please enable it from app settings.',
      );
      return false;
    }

    // إذا تم التفعيل ووجود الإذن

    return true;
  }

  void addPositionToHistory(LatLng position) {
    recentPositions.add(position);
    if (recentPositions.length > 5) {
      recentPositions.removeAt(0); // Keep only the last 5 positions
    }
  }

  void startLocationUpdates() {
    // Location location = Location();
    //? location.changeSettings(

    location.onLocationChanged.listen((loc.LocationData locationData) {
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
    });
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

  void resetRoute() {
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

    // startTimer();
  }

  @override
  void onClose() {
    mapController.dispose();
    // resetRoute();

    super.onClose();
  }
}
