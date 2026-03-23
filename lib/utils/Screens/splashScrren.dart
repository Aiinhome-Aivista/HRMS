import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:hrms/Services/analytics_services.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'dart:async';
import 'package:hrms/utils/Screens/loginSreen.dart';
import 'package:hrms/utils/Widget/bottamNavigationWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// @pragma('vm:entry-point')
// Future<void> startOverlay() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   bool? permission = await FlutterOverlayWindow.isPermissionGranted();

//   await FlutterOverlayWindow.showOverlay(
//     height: 650,
//     width: 850,
//     // enableDrag: true,
//     alignment: OverlayAlignment.center,
//     flag: OverlayFlag.defaultFlag,
//     overlayTitle: "Attendance",
//     overlayContent: 'Overlay Active',
//   );
// }

class SplashScreen extends StatefulWidget {
    final bool fromNotification;

  const SplashScreen({super.key, this.fromNotification = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool showContent = false;
  String latitude = '';
  String longitude = '';
  String empID = '';

  @override
  void initState() {
    super.initState();

    if (widget.fromNotification) {
    // 🔥 Directly go to Attendance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AttendanceScreen(),
        ),
      );
    });

    return; // stop normal flow
  }


    // requestOverlayPermission(); // 👈 ADD THIS
    // scheduleOverlay();



    // Firebase Analytics initialized
    AnalyticsService.logScreen("Splash Screen");

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showContent = true;
      });
      _animationController.forward();
    });

    _savedlatitudelongitude();
  }

// --------------

  Future<void> requestOverlayPermission() async {
    bool? permission = await FlutterOverlayWindow.isPermissionGranted();

    if (permission != true) {
      await FlutterOverlayWindow.requestPermission();
    }
  }

  // -------
  Future<void> scheduleOverlay() async {
    DateTime now = DateTime.now();

    DateTime target = DateTime(
      now.year,
      now.month,
      now.day,
      17,
      20,
    );

    if (target.isBefore(now)) {
      target = target.add(const Duration(seconds: 10));
    }

    print("Alarm scheduled for: $target");

    // await AndroidAlarmManager.oneShotAt(
    //   target,
    //   1, // alarm ID
    //   // startOverlay,
    //   // exact: true,
    //   wakeup: true,
    // );
  }

  // Get local storage data
  Future<void> _savedlatitudelongitude() async {

    if (widget.fromNotification) {
  print("Opened from notification → skip splash navigation");
  return;
}

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? getlatitude = prefs.getString('Savelatitude');
    final String? getlongitude = prefs.getString('Savelongitude');
    final String? getEmpID = prefs.getString('employeeId');

    setState(() {
      latitude = getlatitude ?? '';
      longitude = getlongitude ?? '';
      empID = getEmpID ?? '';
    });
    // print('getlatitude: $latitude');
    // print('getlongitude: $longitude');

    // After checking if latitude and longitude are available, navigate accordingly
    if (latitude.isNotEmpty && longitude.isNotEmpty && empID.isNotEmpty) {
      Timer(const Duration(seconds: 4), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottamnavigationBar()),
        );
      });
    } else {
      Timer(const Duration(seconds: 4), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: showContent ? 0.0 : 1.0,
            duration: const Duration(seconds: 1),
            child: Container(
              color: Colors.black,
              child: Image.asset(
                'assets/images/Splash02.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Visibility(
            visible: showContent,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 90, left: 30, right: 30),
                    child: Column(
                      children: [
                        SlideTransition(
                          position: _slideAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: const Text(
                              'Welcome to',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SlideTransition(
                          position: _slideAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: const Text(
                              'HRMS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.lightblue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SlideTransition(
                          position: _slideAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: const Text(
                              'Attendance made simple, time made yours',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: AppColors.lightblue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.asset(
                        'assets/images/Splash.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
