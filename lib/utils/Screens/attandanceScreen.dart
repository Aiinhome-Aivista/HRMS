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
  List<dynamic> _allAttendanceData = [];
  List<dynamic> _currentAttendance = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    fetchAttendance();
  }

  List filterTodayAttendance(List<dynamic> attendanceData) {
    final String currentDate = DateTime.now().toIso8601String().split('T')[0];

    // Filter data for today's date
    return attendanceData.where((record) {
      return record['date'] == currentDate;
    }).toList();
  }

  void fetchAttendance() async {
    final GET_API getApi = GET_API();
    final result = await getApi.getAttendance('126');

    if (result['status'] == true) {
      // print('Attendance Data: ${result['data']}');

      setState(() {
        _allAttendanceData = result['data'];
      });
      print('Attendance Data: $_allAttendanceData');

      final currentAttendance = filterTodayAttendance(result['data']);
      if (currentAttendance.isNotEmpty) {
        print('Today\'s Attendance Data: $currentAttendance');

        setState(() {
          _currentAttendance = currentAttendance;
        });
      } else {
        print('No attendance record found for today.');
      }
    } else {
      print('Error: ${result['message']}');
    }
  }

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
                DateDisplay(
                  selectedDay: _selectedDay,
                  attendanceData: _allAttendanceData,
                ),
              ],
            ),
          ),
          Expanded(
              child: AttendanceStart(
            currentAttendanceDatais: _currentAttendance,
          )),
        ],
      ),
    );
  }
}
