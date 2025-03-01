import 'package:axion/features/home2_feature/presentation/screens/home_screen.dart';
import 'package:axion/features/map_feature/presentation/screens/map_Screen.dart';
import 'package:axion/features/setting_feature/presentation/screens/setting_screen.dart';
import 'package:axion/features/login_feature/presentation/screens/login.dart';
import 'package:axion/features/map_permission_feature/presentation/screen/map_permission.dart';
import 'package:axion/features/signup_feature/presentation/screen/signup.dart';
import 'package:axion/features/signup_feature/presentation/screen/verification.dart';
import 'package:get/get.dart';

final routes = [
  GetPage(name: '/home', page: () => HomeScreen2()),
  GetPage(name: '/setting', page: () => SettingScreen()),
  GetPage(name: '/login', page: () => Login()),
  GetPage(name: '/signup', page: () => SignUp()),
  GetPage(name: '/map', page: () => MapScreen()),
  GetPage(name: '/mapPermission', page: () => MapScreenPermission()),
  GetPage(name: '/verification', page: () => Verification()),
];
