import 'dart:math';
import 'package:axion/core/constants.dart';
import 'package:axion/features/home_feature/presentation/manger/home_controller.dart';
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
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.route['timestamp']),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _showDeleteConfirmation(context),
      onDismissed: (_) => widget.onDelete(),
      background: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: _buildRouteContent(),
    );
  }

  Widget _buildRouteContent() {
    return Container(
      // width: screenWidth - 40,
      height: 200,
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

    List<LatLng> routePoints =
        (widget.route['route'] as List<dynamic>).map((point) {
      return LatLng(point['lat'], point['lng']);
    }).toList();

    LatLngBounds bounds = homeController.calculateBounds(routePoints);

    final MapController _mapController = MapController();

    void fitCamera() => _mapController.fitCamera(
          CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(40)),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 200,
        width: screenWidth - 40,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            backgroundColor: darkColor,
            initialCenter: LatLng(31.211911, 29.919349),
            initialZoom: 13.0,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.none,
            ),
            onMapReady: () {
              fitCamera();
              setState(() {});
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
                  points: routePoints,
                  strokeWidth: 5,
                  color: pinkColor,
                ),
              ],
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
          value: '${widget.route['averageSpeed'].toStringAsFixed(1)}',
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

