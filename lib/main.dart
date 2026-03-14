import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hrms/overlay/overlay_screen.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:hrms/utils/Screens/splashScrren.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hrms/utils/Widget/attandanceStart.dart';


void main() async {
  // FIrebase initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await AndroidAlarmManager.initialize();


  // Crashlytics initialized
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
    WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Material(child: OverlayScreen()))
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
