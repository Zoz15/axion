import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final routes = <Map<String, dynamic>>[].obs;
  RxDouble avg = 0.0.obs;
  RxDouble dist = 0.0.obs;
  List<double> allAvg = [];
  List<double> allDistanse = [];

  @override
  void onInit() {
    super.onInit();
    loadRoutes();
  }

  Future<void> loadRoutes() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory(directory.path);
    List<Map<String, dynamic>> loadedRoutes = [];
    allAvg = [];
    allDistanse = [];

    try {
      final List<FileSystemEntity> entities = await dir.list().toList();
      for (final entity in entities) {
        if (entity is File && entity.path.endsWith('.json')) {
          final content = await entity.readAsString();
          final data = jsonDecode(content) as Map<String, dynamic>;
          loadedRoutes.add(data);
          allAvg.add(data['averageSpeed']);
          allDistanse.add(data['totalDistance']);
        }
      }
      var sum = 0.0;
      for (var i in allAvg) {
        sum += i;
      }

      avg.value = sum / allAvg.length;

      var sum2 = 0.0;
      for (var i in allDistanse) {
        sum2 += i;
      }
      dist.value = sum2 / allDistanse.length;

      sum2 = 0.0;
      sum = 0.0;
      // allAvg = [];
      // allDistanse = [];

      loadedRoutes.sort((a, b) => DateTime.parse(b['timestamp'])
          .compareTo(DateTime.parse(a['timestamp'])));
      routes.value = loadedRoutes;
    } catch (e) {
      print('Error loading routes: $e');
    }
  }

  Future<void> deleteRoute(int index, Map<String, dynamic> route) async {
    try {
      // Get directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${route['timestamp']}.json');

      // SharedPreferences handling
      final prefs = await SharedPreferences.getInstance();
      final ridesJson = prefs.getStringList('rides') ?? [];
      print('Initial rides: $ridesJson');

      // Remove ride from SharedPreferences
      ridesJson.removeWhere((rideStr) {
        final ride = json.decode(rideStr);
        return ride['timestamp'] == route['timestamp'];
      });
      await prefs.setStringList('rides', ridesJson);
      print('Updated rides: ${prefs.getStringList('rides')}');

      // Remove from list
      routes.removeAt(index);

      // Verify deletion
      final fileDeleted = !(await file.exists());
      final updatedRides = prefs.getStringList('rides') ?? [];
      final prefDeleted = !updatedRides.any((rideStr) {
        final ride = json.decode(rideStr);
        return ride['timestamp'] == route['timestamp'];
      });

      if (fileDeleted && prefDeleted) {
        Get.snackbar(
          'Success',
          'Route completely deleted',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        loadRoutes();
      } else {
        print('File deleted: $fileDeleted, Prefs deleted: $prefDeleted');
        throw Exception('Route not completely deleted');
      }
    } catch (e) {
      print('Error deleting route: $e');
      Get.snackbar(
        'Error',
        'Failed to delete route: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void updateRoutes(List<Map<String, dynamic>> newRoutes) {
    routes.assignAll(newRoutes);
  }


  LatLngBounds calculateBounds(List<LatLng> points) {
  double minLat = points[0].latitude;
  double maxLat = points[0].latitude;
  double minLng = points[0].longitude;
  double maxLng = points[0].longitude;

  for (var point in points) {
    if (point.latitude < minLat) minLat = point.latitude;
    if (point.latitude > maxLat) maxLat = point.latitude;
    if (point.longitude < minLng) minLng = point.longitude;
    if (point.longitude > maxLng) maxLng = point.longitude;
  }

  return LatLngBounds(
    LatLng(minLat, minLng), // الزاوية الجنوبية الغربية
    LatLng(maxLat, maxLng), // الزاوية الشمالية الشرقية
  );
}
}
