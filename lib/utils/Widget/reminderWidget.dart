import 'package:flutter/material.dart';
import 'package:hrms/Services/alarm_service.dart';

class ReminderWidget extends StatefulWidget {
  const ReminderWidget({super.key});

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Set Daily Reminder",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (picked != null) {
              setState(() {
                selectedTime = picked;
              });

              await scheduleDailyAlarm(picked);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Reminder set for ${picked.format(context)}"),
                ),
              );
            }
          },
          child: const Text("Pick Time"),
        ),
        SizedBox(
          height: 50,
        ),
        // if (selectedTime != null)
        //   Text(
        //     "Selected: ${selectedTime!.format(context)}",
        //     style: TextStyle(color: Colors.white),
        //   ),
        selectedTime != null
            ? Text("Reminder set at : ${selectedTime!.format(context)}",
                style: TextStyle(color: Colors.white))
            : Text("Reminder is not set", style: TextStyle(color: Colors.white))
      ],
    );
  }
}