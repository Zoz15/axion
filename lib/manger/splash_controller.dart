import 'package:get/get.dart';

class SplashWidgetController extends GetxController {
  RxBool isTaped = false.obs;
  void onTap() {
    isTaped.value == true ? isTaped.value = false : isTaped.value = true;
  }
}
