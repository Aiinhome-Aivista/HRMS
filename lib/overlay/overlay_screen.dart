import 'package:flutter/material.dart';
import 'package:hrms/utils/Widget/attandanceStart.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          // padding: const EdgeInsets.all(16),
          // color: Colors.blue,
          child: const OverlayAttendanceScreen()
        ),
      ),
    );
  }
}

class OverlayAttendanceScreen extends StatelessWidget {
  const OverlayAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // dummy data (replace with real attendance data)
    List<dynamic> attendanceData = [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 250,
          width: 350,
          // padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black87,
            // borderRadius: BorderRadius.circular(20),
          ),
          child: AttendanceStart(
            currentAttendanceDetails: attendanceData,
          ),
        ),
      ),
    );
  }
}