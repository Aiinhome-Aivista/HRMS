import 'package:flutter/material.dart';
import 'package:hrms/utils/Widget/attandanceStart.dart';
import 'package:hrms/utils/Widget/dateDisplay.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/styleColor.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 45, 16, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Center(
                          child: Text('Attendance', style: HeaderFontStyle.style),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.lightblue),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                DateDisplay(selectedDay: _selectedDay),
              ],
            ),
          ),
          const Expanded(child: AttendanceStart()),
        ],
      ),
    );
  }
}
