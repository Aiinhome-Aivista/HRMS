import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:hrms/overlay/overlay_screen.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:hrms/utils/Screens/splashScrren.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hrms/utils/Widget/attandanceStart.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void alarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized();

  final now = DateTime.now();

  // load saved reminder time
  final prefs = await SharedPreferences.getInstance();
  final hour = prefs.getInt('reminder_hour');
  final minute = prefs.getInt('reminder_minute');

  // if no reminder is saved, stop here
  if (hour == null || minute == null) {
    debugPrint("No saved reminder time found");
    return;
  }

  // Monday to Saturday only
  if (now.weekday != DateTime.sunday) {
    debugPrint("ALARM TRIGGERED 🚀, $now");

    final FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await notifications.initialize(settings: initSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'daily_reminder_channel',
      'Daily Reminder',
      description: 'Daily attendance reminder',
      importance: Importance.max,
    );

    final androidPlugin = notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);

    await notifications.show(
      id: 0,
      title: "Reminder",
      body: "Time to mark your attendance!",
      payload: "open_attendance",
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
  } else {
    debugPrint("Sunday notification skipped");
  }

  // schedule next day at the ORIGINAL saved time
  DateTime nextScheduledTime = DateTime(
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  ).add(const Duration(days: 1));

  await AndroidAlarmManager.oneShotAt(
    nextScheduledTime,
    1,
    alarmCallback,
    wakeup: true,
  );

  debugPrint("Next alarm scheduled for: $nextScheduledTime");
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

  await FirebaseInAppMessaging.instance.setMessagesSuppressed(true);


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
