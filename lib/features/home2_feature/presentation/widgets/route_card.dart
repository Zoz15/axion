import 'dart:math';
import 'package:axion/core/constants.dart';
import 'package:axion/features/home2_feature/presentation/manger/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class RouteCard extends StatefulWidget {
  final Map<String, dynamic> route;
  final VoidCallback onDelete;

  const RouteCard({
    required this.route,
    required this.onDelete,
  });

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  double avg = 0.0;
  @override
  Widget build(BuildContext context) {
    return _buildRouteContent();
  }

  Widget _buildRouteContent() {
    return Container(
      // width: screenWidth - 40,
      height: 300,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          _buildRouteImage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRouteHeader(),
                // SizedBox(height: 100),
                _buildRouteStats(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteImage() {
    HomeController homeController = Get.find();

    List<List<LatLng>> routePoints = (widget.route['route'] as List)
        .map((segment) => (segment as List)
            .map((point) => LatLng(point['lat'], point['lng']))
            .toList())
        .toList();

    List<Color> colorsFromJsonHex(List<dynamic> jsonColors) {
      return jsonColors
          .map((hex) => Color(int.parse(hex.replaceFirst('#', '0xFF'))))
          .toList();
    }

    List<Color> routeColors = colorsFromJsonHex(widget.route['routeColors']);
    List<dynamic> speeds = widget.route['speeds'];
    double sum = speeds.reduce((a, b) => a + b);
    avg = sum / speeds.length;

    // LatLngBounds bounds = homeController.calculateBounds(routePoints);

    final MapController _mapController = MapController();

    Map<String, dynamic> calculateInitialView(List<List<LatLng>> routePoints) {
      if (routePoints.isEmpty || routePoints.first.isEmpty) {
        return {
          'center': const LatLng(31.211911, 29.919349),
          'zoom': 12.0, // قيمة افتراضية
        };
      }

      double minLat = double.infinity, maxLat = double.negativeInfinity;
      double minLng = double.infinity, maxLng = double.negativeInfinity;

      for (var segment in routePoints) {
        for (var point in segment) {
          minLat = min(minLat, point.latitude);
          maxLat = max(maxLat, point.latitude);
          minLng = min(minLng, point.longitude);
          maxLng = max(maxLng, point.longitude);
        }
      }

      LatLng center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);

      // فرق الإحداثيات
      double latDiff = maxLat - minLat;
      double lngDiff = maxLng - minLng;

      // حساب المسافة الفعلية بين أقصى نقطتين (تقريبية)
      double estimatedDistance = sqrt(
          pow(latDiff * 111, 2) + pow(lngDiff * 111, 2)); // 1 درجة ≈ 111 كم

      // تعديل الزوم حسب المسافة:
      double zoom;
      if (estimatedDistance < 2) {
        zoom = 15.5; // تكبير جدًا في المسافات القصيرة (< 2 كم)
      } else if (estimatedDistance < 5) {
        zoom = 14.5; // تكبير متوسط للمسافات المتوسطة (< 5 كم)
      } else if (estimatedDistance < 15) {
        zoom = 13.0; // مستوى جيد للمسافات حتى 15 كم
      } else if (estimatedDistance < 50) {
        zoom = 11.5; // مسافات بين المدن القريبة
      } else {
        zoom = 9.5; // الرحلات الطويلة (> 50 كم)
      }

      return {'center': center, 'zoom': zoom};
    }

    Map<String, dynamic> viewSettings = calculateInitialView(
      routePoints,
    );

    LatLng initialCenter = viewSettings['center'];
    double initialZoom = viewSettings['zoom'];

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 250,
        width: screenWidth - 40,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            backgroundColor: darkColor,
            initialCenter: initialCenter,
            initialZoom: initialZoom - 1.25,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: theMapUrl,
              subdomains: ['a', 'b', 'c', 'd'],
            ),
            PolylineLayer(
              polylines: List.generate(routePoints.length, (index) {
                return Polyline(
                  points: routePoints[index],
                  strokeWidth: 5,
                  color: routeColors[index],
                );
              }),
            ),
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
          widget.route['name'],
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
              widget.route['elapsedTime'],
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: lightColor,
              ),
            ),
            Text(
              _formatTimestamp(DateTime.parse(widget.route['timestamp'])),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: lightBlue,
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
          value: avg.toStringAsFixed(2),
          unit: 'km/h',
          label: 'Avg Speed',
        ),
        _buildStatItem(
          icon: Icons.straighten,
          value: '${widget.route['totalDistance'].toStringAsFixed(2)}',
          unit: 'km',
          label: 'Distance',
        ),
        if (widget.route['details']?.isNotEmpty ?? false)
          _buildStatItem(
            icon: Icons.description,
            value: widget.route['details'],
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
