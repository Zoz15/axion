import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> onTap() async {

  // First attempt to enable location and get permissions
  if (await Geolocator.isLocationServiceEnabled() == false) {
    await Geolocator.openLocationSettings();
    // Add delay to allow user to change settings
    await Future.delayed(Duration(seconds: 2));
  }

  if (await Geolocator.checkPermission() == LocationPermission.denied) {
    await Geolocator.requestPermission();
    // Add delay to allow user to respond to permission request
    await Future.delayed(Duration(seconds: 2));
  }

  if (await Geolocator.checkPermission() == LocationPermission.deniedForever) {
    await Geolocator.openLocationSettings();
    // Add delay to allow user to change settings
    await Future.delayed(Duration(seconds: 2));
  }

  // Check final status
  final permission = await Geolocator.checkPermission();
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  // Check if the permission is already granted
  var status = await Permission.notification.status;
  if (status.isDenied) {
    // Request the permission
    status = await Permission.notification.request();
  }
  if (status.isPermanentlyDenied) {
    openAppSettings();
  }
  bool? isBatteryOptimizationDisabled =
      await DisableBatteryOptimization.isBatteryOptimizationDisabled;

  if (isBatteryOptimizationDisabled == true) {
    await DisableBatteryOptimization
        .showDisableBatteryOptimizationSettings();
  }

  if ((permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) &&
      isLocationEnabled) {
    Get.back();
    Future.delayed(Duration(milliseconds: 200), () {
      Get.toNamed('/map');
    });
  }
}
