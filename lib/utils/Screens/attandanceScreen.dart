import 'package:flutter/material.dart';
import 'package:hrms/Services/api_services.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    // submitAttendance();
  }

  // void submitAttendance() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     String employeeId = "12345";
  //     String updateField = "ClockIn";
  //     String dutyLocation = "Head Office";
  //     String attendance_id = "23454";
  //     String latitude = "12.971598";
  //     String longitude = "77.594566";

  //     POST_API postApi = POST_API();
  //     Map<String, dynamic> result = await postApi.attendance(
  //       employeeId,
  //       updateField,
  //       dutyLocation,
  //       attendance_id,
  //       latitude,
  //       longitude,
  //     );

  //     if (result['status'] == true) {
  //       print("Attendance marked successfully: ${result['message']}");
  //     } else {
  //       print("Failed to mark attendance: ${result['message']}");
  //     }
  //   } catch (e) {
  //     print("Error during attendance API call: $e");
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 45, 16, 6),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Center(
                          child:
                              Text('Attendance', style: HeaderFontStyle.style),
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
