import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:hrms/overlay/overlay_screen.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:hrms/utils/Screens/splashScrren.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hrms/utils/Widget/attandanceStart.dart';

@pragma('vm:entry-point')
void alarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized();

  final now = DateTime.now();

  if (now.weekday == DateTime.sunday) {
    debugPrint("Sunday Notification Skipped");
    return;
  }

  print("ALARM TRIGGERED 🚀, ${now}");

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);

  await notifications.initialize(settings: initSettings);

  // 👇 CREATE CHANNEL (CRITICAL for background)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'daily_reminder_channel',
    'Daily Reminder',
    description: 'Daily attendance reminder',
    importance: Importance.max,
  );

  final androidPlugin = notifications.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();

  await androidPlugin?.createNotificationChannel(channel);

  // 👇 SHOW NOTIFICATION
  await notifications.show(
    id: 0,
    title: "Reminder",
    body: "Time to mark your attendance!",
    payload: "open_attendance", // 👈 IMPORTANT
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_reminder_channel',
        'Daily Reminder',
        channelDescription: 'Daily attendance reminder',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(child: OverlayScreen())));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // FIrebase initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await AndroidAlarmManager.initialize();

  // Crashlytics initialized
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(
    settings: initSettings,
    onDidReceiveNotificationResponse: (response) async {
      if (response.payload == "open_attendance") {
        navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const AttendanceScreen(),
            ),
            (route) => false);
      }
    },
  );

// overlay open
  // await flutterLocalNotificationsPlugin.initialize(
  //   settings: initSettings,
  //   onDidReceiveNotificationResponse: (response) async {
  //     if (response.payload == "open_overlay") {
  //       await FlutterOverlayWindow.showOverlay(); // ✅ NOW SAFE
  //     }
  //   },
  // );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  final NotificationAppLaunchDetails? launchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  runZonedGuarded(() {
    runApp(MyApp(
      launchDetails: launchDetails,
    ));
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

class MyApp extends StatefulWidget {
  final NotificationAppLaunchDetails? launchDetails;

  const MyApp({super.key, this.launchDetails});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     handleNotificationLaunch();
    //   });
    // }

    // void handleNotificationLaunch() {
    //   final details = widget.launchDetails;

    //   if (details != null && details.didNotificationLaunchApp == true) {
    //     final payload = details.notificationResponse?.payload;

    //     if (payload == "open_attendance") {
    //       navigatorKey.currentState?.push(
    //         MaterialPageRoute(
    //           builder: (_) => const AttendanceScreen(),
    //         ),
    //       );
    //     }
    //   }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: SplashScreen(
        fromNotification:
            widget.launchDetails?.didNotificationLaunchApp ?? false,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
