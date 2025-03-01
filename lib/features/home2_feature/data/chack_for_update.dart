import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

Future<void> chackForUpdate() async {
  String currentVersion = '';
  String lastVersion = '';

  final response = await http.get(
      Uri.parse('https://api.github.com/repos/Zoz15/axion/releases/latest'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    lastVersion = data['tag_name'];
    // lastVersion = version.substring(1);
  }

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  currentVersion = packageInfo.version;
  print('-------------------------------');
  print(currentVersion);
  print(lastVersion);

  // Remove the 'v' prefix
  String v1 = currentVersion.replaceFirst('v', '');
  String v2 = lastVersion.replaceFirst('v', '');

  // Split into parts
  List<int> parts1 = v1.split('.').map((e) => int.parse(e)).toList();
  List<int> parts2 = v2.split('.').map((e) => int.parse(e)).toList();

  // Compare versions
  bool isNewVersionAvailable = isVersionNewer(parts1, parts2);

  //todo show dialog
  if (isNewVersionAvailable) {
    print('$lastVersion is newer than $currentVersion');
    // Get.snackbar('Update Available', 'A new version is available: $lastVersion',);
    // Get.showOverlay(asyncFunction: () async {
    //   await Get.defaultDialog(
    //     title: 'Update Available',
    //     middleText: 'A new version is available: $lastVersion',
    //     textConfirm: 'Update',
    //     onConfirm: () {
    //       // Handle update logic
    //     },
    //   );
    // });
     Get.defaultDialog(
    title: 'New Version Available!',
    titleStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    ),
    middleText: 'A new version ($lastVersion) is available. Please update to enjoy the latest features and improvements.',
    middleTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.grey[800],
    ),
    backgroundColor: Colors.white,
    radius: 10,
    content: Column(
      children: [
        Icon(
          Icons.update,
          size: 50,
          color: Colors.blue,
        ),
        SizedBox(height: 10),
        Text(
          'Version $lastVersion',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'What\'s new:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 5),
        Text(
          '- Bug fixes\n- Performance improvements\n- New features',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
    confirm: ElevatedButton(
      onPressed: () {
        // Open the update link (e.g., Play Store or App Store)
        Get.back(); // Close the dialog
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        'Update Now',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ),
    cancel: TextButton(
      onPressed: () {
        Get.back(); // Close the dialog
      },
      child: Text(
        'Later',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
    ),
  );
  } else {
    print('$lastVersion is NOT newer than $currentVersion');
  }
}

bool isVersionNewer(List<int> version1, List<int> version2) {
  for (int i = 0; i < version1.length; i++) {
    if (version2[i] > version1[i]) {
      return true; // version2 is newer
    } else if (version2[i] < version1[i]) {
      return false; // version2 is older
    }
  }
  return false; // versions are equal
}
