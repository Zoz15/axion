import 'dart:async';
import 'package:axion/core/constants.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haversine_distance/haversine_distance.dart';

// import 'package:background_location/background_location.dart';

class MyMapController extends GetxController with SingleGetTickerProviderMixin {
  late final AnimatedMapController mapController;
  final haversine = HaversineDistance();
  //
  // ?points & location
  //
  StreamSubscription<Position>? positionStream;
  var isBatterySaveMode = false.obs;

  //
  //
  //
  RxBool isInBigCounter = false.obs;
  //
  //

  // var roadPoints = <LatLng>[].obs;

  var recordedPoints = <List<LatLng>>[].obs;
  var roadColors = <Color>[].obs;

  //
  //
  //
  //
  //? slider -----------------------
  late AnimationController _controller;
  late Animation<double> _animation;
  RxBool isCounterSliderClose = false.obs;
  RxDouble counterPosition = 0.0.obs;
  double minPosition = -200; // الحد الأعلى (الأعلى في الشاشة)
  double maxPosition = 0; // الحد الأدنى (الأسفل في الشاشة)
  void updatePosition(double delta) {
    double newPosition = counterPosition.value + delta;

    // التأكد أن القيمة لا تتعدى الحدود
    if (newPosition < minPosition) {
      newPosition = minPosition;
    } else if (newPosition > maxPosition) {
      newPosition = maxPosition;
    }

    counterPosition.value = newPosition;
    // print(-screenHeight / 5);
  }

  void handleDragEnd() {
    // تحديد أقرب موضع ثم تشغيل الأنيميشن للوصول إليه
    double targetPosition = (counterPosition.value - minPosition).abs() <
            (counterPosition.value - maxPosition).abs()
        ? minPosition
        : maxPosition;

    animateBetween(targetPosition);
  }

  void animateBetween(double target
      //  RxDouble targetValue,
      // required double target,
      // Curve curve = Curves.easeInOut, // يمكنك تغيير الكيرف حسب الحاجة
      // int durationMs = 500,
      ) {
    _controller.duration = Duration(milliseconds: 500);

    _animation =
        Tween<double>(begin: counterPosition.value, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
            counterPosition.value = _animation.value; // تحديث القيمة في كل فريم
          });

    _controller.forward(from: 0.0);
  }
  //
  //
  //
  //
  //

  Rx<LatLng> currentPosition = LatLng(31.211911, 29.919349).obs;
  var speeds = <double>[].obs;
  var avg = 0.0.obs;
  Rx<double> totalDistance = 0.0.obs;
  var currentSpeed = 0.0.obs;
  //
  //?map
  //
  var currentZoom = 17.0.obs;
  var isFollowingUser = true.obs;

  var isPaused = false.obs; // لتحديد ما إذا كانت الرحلة في حالة إيقاف مؤقت
  // var isAutoPaused = false.obs;
  // var isRideing = false.obs;
  RxBool isStart = false.obs;

  RxString elapsedTime = '00:00:00'.obs;
  RxInt hower = 0.obs; // عدد الثواني
  RxInt minutes = 0.obs; // عدد الدقائق
  RxInt seconds = 0.obs; // عدد الثواني

  // Timer? _timer;
  LatLng? lastPosition;
  Timer? _timer;
  // int elapsedSeconds = 0;

  @override
  void onInit() {
    super.onInit();
    startLocationUpdates();

    isInBatterySaveMode();
    startTimer();
    mapController = AnimatedMapController(vsync: this);
    //? background location 😊😊
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_channel',
        channelName: 'Recording',
        channelDescription: 'Recording location in the background',
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        autoRunOnBoot: true,
        allowWifiLock: true,
        eventAction: ForegroundTaskEventAction.repeat(
          AndroidPointerProperties.kToolTypeEraser,
        ),
      ),
    );
    // //? background location

    recordedPoints.add([]);
    roadColors.add(orangeColor);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> isInBatterySaveMode() async {
    Battery battery = Battery();
    if (await battery.isInBatterySaveMode) isBatterySaveMode.value = true;
  }

  Future<void> startLocationUpdates() async {
    try {
      await positionStream?.cancel();

      Position initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      currentPosition.value =
          LatLng(initialPosition.latitude, initialPosition.longitude);

      // Initialize position stream with more frequent updates
      positionStream = Geolocator.getPositionStream(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0, // Update regardless of distance moved
          intervalDuration:
              const Duration(seconds: 1), // Get updates every second
          //// Optional: Adjust these settings based on your needs
          forceLocationManager: true, // Use Android's LocationManager
        ),
      ).listen(
        (Position position) {
          if (isStart.value == true) {
            if (isPaused.value == false) {
              getDisance(position);
            }

            recordedPoints.last
                .add(LatLng(position.latitude, position.longitude));
            // roadPoints.add(LatLng(position.latitude, position.longitude));
          }
          currentPosition.value = LatLng(position.latitude, position.longitude);
        },
        onError: (error) {
          print('Location Error: $error');
          // Attempt to restart location updates after error
          Future.delayed(const Duration(seconds: 1), () {
            startLocationUpdates();
          });
        },
        cancelOnError: false,
      );

      // Start foreground service
      await FlutterForegroundTask.startService(
        notificationTitle: 'تتبع الموقع',
        notificationText: 'التطبيق يتتبع الموقع في الخلفية.',
        notificationIcon: NotificationIcon(metaDataName: 'ic_launcher'),
      );
    } catch (e) {
      print('Error starting location updates: $e');
      // Attempt to restart location updates after error
      Future.delayed(const Duration(seconds: 1), () {
        startLocationUpdates();
      });
    }
  }

  void getDisance(Position position) {
    if (lastPosition != null) {
      double distance = haversine.haversine(
        Location(position.latitude, position.longitude),
        Location(lastPosition!.latitude, lastPosition!.longitude),
        Unit.METER,
      );
      if (distance > 3) {
        totalDistance.value += distance / 1000;
      }
    }
    lastPosition = LatLng(position.latitude, position.longitude);
    getSpeed();
  }

  void getSpeed() {
    double timeInSeconds =
        (seconds.value + (minutes.value * 60) + (hower.value * 3600))
            .toDouble();

    double distance = totalDistance.value * 1000; // convert to meter

    if (timeInSeconds > 0 && distance > 0) {
      double speed = (distance / timeInSeconds) * 3.6; // convert to km/h
      // if (speed < 100) {
      speeds.add(speed);
      // currentSpeed.value = speed;
      // }

      // get last 3 speeds and get the avg
      if (speeds.length >= 3) {
        var last3Speeds = speeds.sublist(speeds.length - 3);
        var avg3Speed =
            last3Speeds.reduce((a, b) => a + b) / last3Speeds.length;
        currentSpeed.value = avg3Speed;
      }

      getAvgSpeed();

      // chickAutoPause();
    }
  }

  // void chickAutoPause() {
  //   if (isPaused.value == false) {
  //     // isPaused.value = true;
  //     double first = speeds[speeds.length - 1];
  //     double second = speeds[speeds.length - 2];
  //     double third = speeds[speeds.length - 3];
  //     double fourth = speeds[speeds.length - 4];

  //     double sum = first + second + third + fourth;
  //     double avg = sum / 4;
  //     if (avg < 5) {
  //       isAutoPaused.value = true;
  //       isPaused.value = true;
  //     } else {
  //       if (isAutoPaused.value == true) {
  //         isAutoPaused.value = false;
  //         isPaused.value = false;
  //       }
  //     }
  //   }
  // }

  void getAvgSpeed() {
    // print('speeds: ${speeds.length}');
    if (speeds.isEmpty) {
      avg.value = 0.0;
      return;
    }

    var filteredSpeeds =
        speeds.where((speed) => speed > 0 && speed < 100).toList();

    if (filteredSpeeds.isEmpty) {
      avg.value = 0.0;
      return;
    }

    // Calculate average speed
    double sum = filteredSpeeds.reduce((a, b) => a + b);
    avg.value = sum / filteredSpeeds.length;
    // print('the avg is added');
    // print('avg: $avg');
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPaused.value == false && isStart.value == true) {
        if (isPaused.value) {
          timer.cancel();
          // print('timer stop');
          return;
        }

        seconds.value++;
        if (seconds.value == 60) {
          seconds.value = 0;
          minutes.value++;
          if (minutes.value == 60) {
            minutes.value = 0;
            hower.value++;
          }
        }

        elapsedTime.value =
            '${hower.value.toString().padLeft(2, '0')}:${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}';
        // print(elapsedTime.value);
      }
    });
  }

  void toggleFollowingUser() {
    isFollowingUser.value = !isFollowingUser.value;
  }

  void moveToCurrentLocation() {
    mapController.animateTo(
      dest: currentPosition.value,
      zoom: currentZoom.value,
    );
  }

  Future<void> resetRoute() async {
    if (recordedPoints.isEmpty) return; // Add null check

    await FlutterForegroundTask.stopService();
    recordedPoints.clear();
    currentPosition.value =
        LatLng(31.211911, 29.919349); // Set default position
    totalDistance.value = 0.0;
    currentSpeed.value = 0.0;
    lastPosition = null;
    _timer?.cancel();
    seconds.value = 0;
    minutes.value = 0;
    hower.value = 0;
  }

  void toggleRide() {
    isStart.value = true;
    // isAutoPaused.value = false;
    isPaused.value = !isPaused.value;

    if (isPaused.value == true) {
      _timer?.cancel();
    }

    if (isPaused.value) {
      // عند التوقف، أضف مسارًا جديدًا رماديًا
      var lastLocathion = currentPosition.value;
      recordedPoints.add([]);
      recordedPoints.last.add(lastLocathion);
      roadColors.add(Colors.grey);
    } else {
      // عند الاستئناف، تحقق إن كان آخر مسار رمادي، وأضف مسارًا برتقاليًا جديدًا
      if (roadColors.isNotEmpty && roadColors.last == Colors.grey) {
        var lastLocathion2 = currentPosition.value;
        recordedPoints.add([]);
        recordedPoints.last.add(lastLocathion2);
        roadColors.add(orangeColor);
      }
    }
    startTimer();
  }

  @override
  @override
  void onClose() {
    // if (roadPoints.isEmpty) return; // Add null check

    mapController.dispose();
    _controller.dispose();

    // currentPosition.value = roadPoints.last;
    positionStream?.cancel();
    super.onClose();
  }
}
