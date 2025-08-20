import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

Future<void> onTapChickLocation() async {
  bool isLocation = await chickLocation();
  if (isLocation == true) {
    Get.toNamed('/map');
  }
}

Future<bool> chickLocation() async {
  print(
      'isLocationServiceEnabled: ${await Geolocator.isLocationServiceEnabled()}');
  print('checkPermission: ${await Geolocator.checkPermission()}');
  print('checkPermission: ${await Geolocator.checkPermission()}');

  if (await Geolocator.isLocationServiceEnabled() == false ||
      await Geolocator.checkPermission() == LocationPermission.denied ||
      await Geolocator.checkPermission() == LocationPermission.deniedForever) {
    // final status = await Permission.notification.status;
    Get.toNamed('/mapPermission');

    return false;
  } else {
    return true;
  }
}
