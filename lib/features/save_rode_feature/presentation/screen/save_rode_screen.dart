import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:axion/features/home_feature/presentation/manger/home_controller.dart';
import 'package:axion/features/map_feature/presentation/manger/map_controller.dart';
import 'package:axion/core/constants.dart';

class SaveRouteScreen extends StatefulWidget {
  final List<LatLng> recordedPoints;
  final double totalDistance;
  final String elapsedTime;
  final double averageSpeed;

  SaveRouteScreen({
    required this.recordedPoints,
    required this.totalDistance,
    required this.elapsedTime,
    required this.averageSpeed,
  });

  @override
  _SaveRouteScreenState createState() => _SaveRouteScreenState();
}

class _SaveRouteScreenState extends State<SaveRouteScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  final timestamp = DateTime.now().toIso8601String();

  Future<void> _saveRoute() async {
    if (widget.recordedPoints.length < 10 ||
        widget.recordedPoints.isEmpty ||
        widget.averageSpeed < 5) {
      Get.snackbar(
        'This is not a valid route',
        'Please continue your route',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a title for your route',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final filePath = await _getFilePath();
    final file = File(filePath);

    final data = {
      'name': _nameController.text,
      'details': _detailsController.text,
      'route': widget.recordedPoints
          .map((point) => {'lat': point.latitude, 'lng': point.longitude})
          .toList(),
      'totalDistance': widget.totalDistance,
      'elapsedTime': widget.elapsedTime,
      'averageSpeed': widget.averageSpeed,
      'timestamp': timestamp,
    };

    await file.writeAsString(jsonEncode(data));

    final homeController = Get.find<HomeController>();
    final mapController = Get.find<MyMapController>();
    mapController.resetRoute();
    // Navigate back to home and remove all previous routes
    homeController.loadRoutes();
    Get.offAllNamed('/home');
    // Get.offAllNamed HomeScreen();
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$timestamp.json';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        backgroundColor: darkColor,
        elevation: 0,
        title: Text(
          'Save Your Ride',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Summary
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: lightOfDarkColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Distance',
                            '${widget.totalDistance.toStringAsFixed(2)} km'),
                        _buildStatItem('Time', widget.elapsedTime),
                        _buildStatItem('Avg Speed',
                            '${widget.averageSpeed.toStringAsFixed(1)} km/h'),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Title Field
                  Text(
                    'Title',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Morning Ride',
                      hintStyle: GoogleFonts.cairo(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[800]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Description Field
                  Text(
                    'Description',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: _detailsController,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'How was your ride?',
                      alignLabelWithHint: true,
                      hintStyle: GoogleFonts.cairo(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[800]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  // Save Button
                  // Spacer(),

                  Row(
                    children: [
                      Text(
                        'Not need to save? ',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          final locationController =
                              Get.find<MyMapController>();
                          Get.offAllNamed('/home');
                          // locationController.resetRoute();
                          locationController.resetRoute();
                        },
                        child: Text(
                          'Discard',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            InkWell(
              onTap: _saveRoute,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: pinkColor,
                ),
                child: Center(
                  child: Text(
                    'SAVE',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
