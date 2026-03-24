import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:hrms/Services/alarm_service.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
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

  void _showReminderModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      isScrollControlled: true, // 👈 IMPORTANT

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.5, // 👈 50% of screen height (adjust this)

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Reminder Settings",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),

                const SizedBox(height: 20),

                // ✅ SET TIME
                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.white),
                  title: const Text(
                    "Set Time",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    final picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime ?? TimeOfDay.now(),
                    );

                    if (picked != null) {
                      setState(() {
                        selectedTime = picked;
                      });

                      await saveTime(picked);
                      await scheduleDailyAlarm(picked);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Reminder set for ${picked.format(context)}"),
                        ),
                      );
                    }
                  },
                ),

                // ✅ DELETE REMINDER
                if (selectedTime != null)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      "Delete Reminder",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await clearReminder();
                    },
                  ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Column(
        children: [
          Text(
            "Daily Reminder",
            style: HeaderFontStyle.style,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedTime != null
                    ? "Reminder at ${selectedTime!.format(context)}"
                    : "Reminder is OFF",
                style: TextStyle(color: AppColors.lightblue, fontSize: 20),
              ),
              Switch(
                value: selectedTime != null,
                activeColor: AppColors.greyShade,
                onChanged: (value) async {
                  if (value) {
                    _showReminderModal(context); // 👉 ONLY switch triggers this
                  } else {
                    await clearReminder();
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
