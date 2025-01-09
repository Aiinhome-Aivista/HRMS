import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/Services/api_services.dart';
import 'package:hrms/components/showToast.dart';
import 'package:hrms/styleColor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceStart extends StatefulWidget {
  final List<dynamic> currentAttendanceDetails;
  const AttendanceStart({super.key, required this.currentAttendanceDetails});

  @override
  State<AttendanceStart> createState() => _AttendanceStartState();
}

class _AttendanceStartState extends State<AttendanceStart> {
  double _xOffset = 0;
  double _yOffset = 0;
  final double _swipeThreshold = 50.0;

  String? _swipeDirection;
  double _leftLimit = 0;
  double _rightLimit = 0;
  double _topLimit = 0;
  double _bottomLimit = 0;

  List<dynamic> _currentAttendanceData = [];
  String currentDateLoginTime = '';
  String currentBreakStartTime = '';
  String currentBreakCompletionTime = '';
  String currentLogoutTime = '';
  String _swipeDirectionIS = '';
  String employeeId = '';
  String attendanceId = '';
  String updateField = '';
  String dutyLocation = '';
  String latitude = '';
  String longitude = '';
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  Timer? _timer;
  bool _isLocationUpdating = false;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
    _loadSavedCredentials();
    fetchLocation();
  }

//get employeeId from local storage
  Future<void> _loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? Employee_Id = prefs.getString('employeeId');
    setState(() {
      employeeId = Employee_Id ?? '';
    });
  }

//fetch location
  Future<void> fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          latitude = position.latitude.toString();
          longitude = position.longitude.toString();
        });
      }
    } catch (e) {
      //print("Error fetching location: $e");
    }
  }

//location update
  void updateLocation() async {
    await fetchLocation();
    if (employeeId.isEmpty) {
      //print("Error: Employee ID is missing.");
      return;
    }
    if (latitude.isEmpty || longitude.isEmpty) {
      //print("Error: Latitude or Longitude is missing.");
      return;
    }

    //print(
    // "Employee ID: $employeeId, Latitude: $latitude, Longitude: $longitude, Date: $date");

    try {
      POST_API postApi = POST_API();
      Map<String, dynamic> response =
          await postApi.locationUpdate(employeeId, latitude, longitude, date);

      if (response['status'] == true) {
        //print("Location update successful: ${response['message']}");
      } else {
        //print("Location update failed: ${response['message']}");
      }
    } catch (e) {
      //print("Error calling locationUpdate API: $e");
    }
  }

//update location start
  void startUpdatingLocation() {
    if (!_isLocationUpdating) {
      _isLocationUpdating = true;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(hours: 1), (timer) {
        // //print("api call in every 1 hours");
        updateLocation();
      });
    }
  }

//update location stop
  void stopUpdatingLocation() {
    _isLocationUpdating = false;
    _timer?.cancel();
    _timer = null;
  }

//fetch employee attendance
  void fetchAttendance() async {
    setState(() {
      _currentAttendanceData = widget.currentAttendanceDetails;

      if (_currentAttendanceData.isNotEmpty) {
        attendanceId = (_currentAttendanceData[0]['id'] ?? '').toString();
        currentDateLoginTime =
            (_currentAttendanceData[0]['login_time'] ?? '').toString();
        currentBreakStartTime =
            (_currentAttendanceData[0]['break_start_time'] ?? '').toString();
        currentBreakCompletionTime =
            (_currentAttendanceData[0]['break_completion_time'] ?? '')
                .toString();
        currentLogoutTime =
            (_currentAttendanceData[0]['logout_time'] ?? '').toString();
      } else {
        //print("No attendance data available");
        attendanceId = '';
        currentDateLoginTime = '';
        currentBreakStartTime = '';
        currentBreakCompletionTime = '';
        currentLogoutTime = '';
      }
    });
  }

  _handleSwipeCompletion() async {
    if (_xOffset.abs() > _swipeThreshold || _yOffset.abs() > _swipeThreshold) {
      if (currentDateLoginTime.isEmpty) {
        if (_yOffset > 0 && _xOffset == 0) {
          _swipeDirectionIS = 'Client_site';
        } else if (_yOffset < 0 && _xOffset == 0) {
          _swipeDirectionIS = 'pwc';
        } else if (_xOffset > 0 && _yOffset == 0) {
          _swipeDirectionIS = 'Head_Office';
        } else if (_xOffset < 0 && _yOffset == 0) {
          _swipeDirectionIS = 'Home';
        } else {
          _swipeDirectionIS = 'Unknown';
        }

        setState(() {
          dutyLocation = _swipeDirectionIS;
          updateField = 'login_time';
          currentDateLoginTime = 'skip';
        });
      } else if (currentDateLoginTime.isNotEmpty &&
          currentBreakStartTime.isEmpty) {
        _swipeDirectionIS = _xOffset > 0 ? 'skip_next' : 'break_start_time';
        setState(() {
          updateField = _swipeDirectionIS;
          currentDateLoginTime = 'skip';
          currentBreakStartTime = 'skip';
        });
      } else if (currentDateLoginTime.isNotEmpty &&
          currentBreakStartTime.isNotEmpty &&
          currentBreakCompletionTime.isEmpty) {
        _swipeDirectionIS =
            _xOffset > 0 ? 'skip_next' : 'break_completion_time';
        setState(() {
          updateField = _swipeDirectionIS;
          currentDateLoginTime = 'skip';
          currentBreakStartTime = 'skip';
          currentBreakCompletionTime = 'skip';
        });
      } else {
        _swipeDirectionIS = _yOffset > 0 ? 'logout_time' : '';
        setState(() {
          updateField = _swipeDirectionIS;
          currentDateLoginTime = 'skip';
          currentBreakStartTime = 'skip';
          currentBreakCompletionTime = 'skip';
          currentLogoutTime = 'skip';
        });
      }

      //print('Swipe Direction: $_swipeDirectionIS');
      //print('Duty Location: $dutyLocation');
    }
    submitAttendance();
  }

  void _resetPosition() {
    setState(() {
      _xOffset = 0;
      _yOffset = 0;
      _swipeDirection = null;
    });
  }

  void submitAttendance() async {
    try {
      POST_API postApi = POST_API();
      Map<String, dynamic> result = await postApi.attendance(
        employee_id: employeeId,
        update_field: updateField,
        duty_location: dutyLocation,
        attendance_id: attendanceId,
        latitude: latitude,
        longitude: longitude,
      );
      //print('Apiiiiiiiiii send item: $result');

      if (result['status'] == true) {
        //print("Attendance marked successfully: ${result['message']}");
        CustomToast.show(context, result['message']);
      } else {
        //print("Failed to mark attendance: ${result['message']}");
      }
    } catch (e) {
      //print("Error during attendance API call: $e");
    } finally {}
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    const double buttonSize = 80.0;

    _leftLimit = -(screenWidth * 0.1 + buttonSize / 2);
    _rightLimit = screenWidth * 0.1 + buttonSize / 2;
    _topLimit = -(screenHeight * 0.2 - buttonSize);
    _bottomLimit = screenHeight * 0.2 - buttonSize;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _swipeDirection = (details.delta.dx.abs() > details.delta.dy.abs())
              ? 'horizontal'
              : 'vertical';

          if (currentDateLoginTime.isEmpty) {
            if (_swipeDirection == 'horizontal') {
              _xOffset += details.delta.dx;
              _yOffset = 0;
            } else if (_swipeDirection == 'vertical') {
              _yOffset += details.delta.dy;
              _xOffset = 0;
            }
          } else if (currentBreakStartTime.isEmpty) {
            _yOffset = 0;
            _xOffset += details.delta.dx;
          } else if (currentBreakCompletionTime.isEmpty) {
            _yOffset = 0;
            _xOffset += details.delta.dx;
          } else if (currentLogoutTime.isEmpty) {
            _yOffset += details.delta.dy;
            _xOffset = 0;
            if (_yOffset < 0) _yOffset = 0;
          } else {
            if (_swipeDirection == 'horizontal') {
              _xOffset += details.delta.dx;
              _yOffset = 0;
            } else {
              _yOffset = 0;
            }
          }

          if (_xOffset < _leftLimit) _xOffset = _leftLimit;
          if (_xOffset > _rightLimit) _xOffset = _rightLimit;
          if (_yOffset < _topLimit) _yOffset = _topLimit;
          if (_yOffset > _bottomLimit) _yOffset = _bottomLimit;
        });
      },
      onPanEnd: (details) async {
        await _handleSwipeCompletion();
        _resetPosition();
        // await Future.delayed(const Duration(seconds: 1));
        // Navigator.pop(context);
      },
      child: Stack(
        children: [
          _buildAttendanceStateUI(),
        ],
      ),
    );
  }

  Widget _buildAttendanceStateUI() {
    if (currentDateLoginTime.isEmpty) {
      return _buildSelectWorkLocation(context);
    } else if (currentLogoutTime.isNotEmpty) {
      return _finalDone(context);
    } else {
      if (currentDateLoginTime.isNotEmpty &&
          currentBreakStartTime.isNotEmpty &&
          currentBreakCompletionTime.isNotEmpty &&
          currentLogoutTime.isEmpty) {
        return _buildPunchOut(context);
      } else if (currentDateLoginTime.isNotEmpty &&
          currentBreakStartTime.isEmpty) {
        return _buildBreakStart(context);
      } else if (currentDateLoginTime.isNotEmpty &&
          currentBreakStartTime.isNotEmpty &&
          currentBreakCompletionTime.isEmpty) {
        return _buildBreakComplete(context);
      } else {
        return _finalDone(context);
      }
    }
  }

  Widget _buildSwipeControl() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.translationValues(_xOffset, _yOffset, 0),
      alignment: Alignment.center,
      child: SvgPicture.asset('assets/images/swip.svg'),
    );
  }

  Widget _buildSelectWorkLocation(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIcon(
          iconPath: 'assets/images/pwc.svg',
          isHighlighted: _swipeDirectionIS == 'pwc',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIcon(
              iconPath: 'assets/images/home.svg',
              isHighlighted: _swipeDirectionIS == 'Home',
            ),
            _buildSwipeControl(),
            _buildIcon(
              iconPath: 'assets/images/office.svg',
              isHighlighted: _swipeDirectionIS == 'Head_Office',
            ),
          ],
        ),
        _buildIcon(
          iconPath: 'assets/images/client.svg',
          isHighlighted: _swipeDirectionIS == 'Client_site',
        ),
      ],
    );
  }

  Widget _buildBreakStart(BuildContext context) {
    if (!_isLocationUpdating) {
      startUpdatingLocation();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIcon(
          iconPath: 'assets/images/break_start.svg',
          isHighlighted: _swipeDirectionIS == 'break_start_time',
        ),
        _buildSwipeControl(),
        _buildIcon(
          iconPath: 'assets/images/Skip_next.svg',
          isHighlighted: _swipeDirectionIS == 'Skip_next',
        ),
      ],
    );
  }

  Widget _buildBreakComplete(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIcon(
          iconPath: 'assets/images/break_complete.svg',
          isHighlighted: _swipeDirectionIS == 'break_completion_time',
        ),
        _buildSwipeControl(),
        _buildIcon(
          iconPath: 'assets/images/Skip_next.svg',
          isHighlighted: _swipeDirectionIS == 'Skip_next',
        ),
      ],
    );
  }

  Widget _buildPunchOut(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(height: 50),
        _buildSwipeControl(),
        _buildIcon(
          iconPath: 'assets/images/punch_out.svg',
          isHighlighted: _swipeDirectionIS == 'logout_time',
        ),
      ],
    );
  }

  Widget _finalDone(BuildContext context) {
    if (!_isLocationUpdating) {
      stopUpdatingLocation();
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/final_thankyou.svg',
            height: 68,
            width: 96,
            color: AppColors.lightblue,
          ),
          const SizedBox(height: 10),
          const Text(
            'Thank you have a',
            style: TextStyle(
              color: AppColors.greyShade2,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'good day',
            style: TextStyle(
              color: AppColors.greyShade2,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon({
    required String iconPath,
    required bool isHighlighted,
  }) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isHighlighted ? AppColors.greyShade2 : Colors.white,
        BlendMode.srcIn,
      ),
      child: SvgPicture.asset(
        iconPath,
        height: 50,
        width: 50,
      ),
    );
  }
}
