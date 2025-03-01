
import 'dart:convert';

import 'package:axion/features/home2_feature/presentation/manger/home_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final controller = Get.find<HomeController>();
Future<void> handleRouteDelete(int index, Map<String, dynamic> route) async {
    await controller.deleteRoute(index, route);
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

