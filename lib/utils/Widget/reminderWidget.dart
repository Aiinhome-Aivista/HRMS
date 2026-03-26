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
      if (!mounted) return;
      setState(() {
        selectedTime = TimeOfDay(hour: hour, minute: minute);
      });
    }
  }

  // ✅ SAVE time
  Future<void> saveTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);
  }

  // ✅ CLEAR reminder
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
    loadSavedTime();
  }

  void _showReminderModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reminder Settings",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),

                // ✅ SET TIME
                ListTile(
                  contentPadding: EdgeInsets.zero,
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

                // ✅ DELETE
                if (selectedTime != null)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ KEY FIX
        children: [
          /// 🔥 REMINDER ROW
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.card, // 👈 matches HRMS cards
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// TEXT
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reminder",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : "OFF",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                /// SWITCH
                Switch(
                  value: selectedTime != null,
                  activeColor: AppColors.greyShade,
                  onChanged: (value) async {
                    if (value) {
                      _showReminderModal(context);
                    } else {
                      await clearReminder();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}