


// ====================corrected version======================
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:hrms/main.dart';

Future<void> scheduleDailyAlarm(TimeOfDay time) async {
  final now = DateTime.now();

  DateTime scheduledTime = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  if (scheduledTime.isBefore(now)) {
    scheduledTime = scheduledTime.add(const Duration(days: 1));
  }

    // skip Sunday for the first scheduled alarm too
  if (scheduledTime.weekday == DateTime.sunday) {
    scheduledTime = scheduledTime.add(const Duration(days: 1));
  }

  print("Alarm scheduled for: $scheduledTime");

  // 👇 cancel previous alarm
  await AndroidAlarmManager.cancel(1);

  // 👇 schedule ONE-TIME alarm at exact time
  await AndroidAlarmManager.oneShotAt(
    scheduledTime,
    1,
    alarmCallback,
    wakeup: true,
  );
}
