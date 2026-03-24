import 'package:flutter/material.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:hrms/utils/Widget/reminderWidget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 75),
            ReminderWidget(),
          ],
        ),
      ),
    );
  }
}
