import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:hrms/Services/alarm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderWidget extends StatefulWidget {
  const ReminderWidget({super.key});

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  TimeOfDay? selectedTime;

  // ✅ LOAD saved time
  Future<void> loadSavedTime() async {
    final prefs = await SharedPreferences.getInstance();

    final hour = prefs.getInt('reminder_hour');
    final minute = prefs.getInt('reminder_minute');

    if (hour != null && minute != null) {
      if (!mounted) return; // ✅ ADD THIS
      setState(() {
        selectedTime = TimeOfDay(hour: hour, minute: minute);
      });

      print("Loaded reminder: $selectedTime");
    }
  }

  // ✅ SAVE time
  Future<void> saveTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);
  }

  // ✅ CLEAR reminder (optional but useful)
  Future<void> clearReminder() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('reminder_hour');
    await prefs.remove('reminder_minute');

    await AndroidAlarmManager.cancel(1);

    setState(() {
      selectedTime = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Reminder cleared")),
    );
  }

  @override
  void initState() {
    super.initState();
    loadSavedTime(); // 👈 restore on startup
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Set Daily Reminder",
          style: TextStyle(color: Colors.white),
        ),

        const SizedBox(height: 30),

        // ✅ PICK TIME BUTTON
        ElevatedButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );

            if (picked != null) {
              setState(() {
                selectedTime = picked;
              });

              await saveTime(picked); // ✅ SAVE
              await scheduleDailyAlarm(picked); // ✅ SCHEDULE

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Reminder set for ${picked.format(context)}"),
                ),
              );
            }
          },
          child: const Text("Pick Time"),
        ),

        const SizedBox(height: 30),

        // ✅ DISPLAY STATUS
        selectedTime != null
            ? Text(
                "Reminder set at: ${selectedTime!.format(context)}",
                style: const TextStyle(color: Colors.white),
              )
            : const Text(
                "Reminder is not set",
                style: TextStyle(color: Colors.white),
              ),

        const SizedBox(height: 20),

        // ✅ CLEAR BUTTON (optional but recommended)
        if (selectedTime != null)
          ElevatedButton(
            onPressed: clearReminder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Clear Reminder"),
          ),
      ],
    );
  }
}
