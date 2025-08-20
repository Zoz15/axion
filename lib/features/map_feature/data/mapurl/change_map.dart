
import 'package:axion/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> getLinkMapFromStroage() async {
  final prefs = await SharedPreferences.getInstance();
  theMapUrl = prefs.getString('text') ?? mapLinks[0];
}
