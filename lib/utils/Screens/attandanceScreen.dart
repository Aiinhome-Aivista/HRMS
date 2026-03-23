import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:hrms/Services/api_services.dart';
import 'package:hrms/components/loading_spinner.dart';
import 'package:hrms/utils/Widget/attandanceStart.dart';
import 'package:hrms/utils/Widget/bottamNavigationWidget.dart';
import 'package:hrms/utils/Widget/dateDisplay.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/utils/Widget/reminderWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrms/services/alarm_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late DateTime _selectedDay;
  List<dynamic> _allAttendanceData = [];
  List<dynamic> _currentAttendance = [];
  bool _isLoading = false;
  String empId = '';

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    // fetchAttendance();
    _loadSavedCredentials();
  }

  List filterTodayAttendance(List<dynamic> attendanceData) {
    final String currentDate = DateTime.now().toIso8601String().split('T')[0];

    // Filter data for today's date
    return attendanceData.where((record) {
      return record['date'] == currentDate;
    }).toList();
  }

  // Get local storage data
  Future<void> _loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? employeeId = prefs.getString('employeeId');
    print("empIddddddddddddddddddddddsssssssssd:$employeeId");
    setState(() {
      empId = employeeId ?? '';
    });
    //print("empIddddddddddddddddddddddd:$empId");
    await fetchAttendance();
  }

  fetchAttendance() async {
    setState(() {
      _isLoading = true;
    });
    final GET_API getApi = GET_API();
    final result = await getApi.getAttendance(empId);

    if (result['status'] == true) {
      setState(() {
        _allAttendanceData = result['data'];
      });
      // print('All Attendance Data: $_allAttendanceData');

      final currentAttendance = filterTodayAttendance(result['data']);
      if (currentAttendance.isNotEmpty) {
        print('Todays Attendance Data: $currentAttendance');

        setState(() {
          _currentAttendance = currentAttendance;
        });
      } else {
        //print('No attendance record found for today.');
      }
    } else {
      //print('Error: ${result['message']}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // overlay func

  Future<void> startOverlay() async {
    bool? permission = await FlutterOverlayWindow.isPermissionGranted();

    if (permission != true) {
      await FlutterOverlayWindow.requestPermission();
    }

    await FlutterOverlayWindow.showOverlay(
      height: 650,
      width: 850,
      // enableDrag: true,
      alignment: OverlayAlignment.center,
      flag: OverlayFlag.defaultFlag,
      overlayTitle: "Attendance",
      overlayContent: 'Overlay Active',
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const BottamnavigationBar(),
            ),
            (route) => false,
          );
        },
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          body: _isLoading
              ? const Center(
                  child: LoadingSpinner(),
                )
              : Column(
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
                                    child: Text('Attendance',
                                        style: HeaderFontStyle.style),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: AppColors.lightblue),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const BottamnavigationBar(),
                                    ),
                                    (route) => false,
                                  );
                                },
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
                    // SizedBox(
                    //   height: 100,
                    // ),
                    // ElevatedButton(
                    //   onPressed: startOverlay,
                    //   child: const Text("Floating Window"),
                    // ),
                    // SizedBox(
                    //   height: 100,
                    // ),
                    // ReminderWidget(),
                    Expanded(
                        child: AttendanceStart(
                      currentAttendanceDetails: _currentAttendance,
                    )),
                  ],
                ),
        ));
  }
}
