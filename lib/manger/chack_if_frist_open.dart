// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CheckIfFirstOpen extends GetxController {
//   RxBool isFirstOpen = false.obs;

//   void check() async {
//     final prefs = await SharedPreferences.getInstance();
//     isFirstOpen.value = prefs.getBool('isFirstOpen') ?? false;
//     if (isFirstOpen.value) {
//       isFirstOpen.value = false;
//       await prefs.setBool('isFirstOpen', false);
//     }
//   }
// }
