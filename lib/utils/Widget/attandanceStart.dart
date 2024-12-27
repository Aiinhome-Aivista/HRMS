import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/Services/api_services.dart';
import 'package:hrms/components/showToast.dart';
import 'package:hrms/styleColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AttendanceStart extends StatefulWidget {
  final List<dynamic> currentAttendanceDatais;
  const AttendanceStart({super.key, required this.currentAttendanceDatais});

  @override
  State<AttendanceStart> createState() => _AttendanceStartState();
}

class _AttendanceStartState extends State<AttendanceStart> {
  double _xOffset = 0;
  double _yOffset = 0;
  final double _swipeThreshold = 50.0;
  bool _isSelectWorkLocation = false;
  bool _isSelectBreakStart = false;
  bool _isSelectBreakComplete = false;
  bool _isSelectPunchOut = false;

  String? _swipeDirection;
  double _leftLimit = 0;
  double _rightLimit = 0;
  double _topLimit = 0;
  double _bottomLimit = 0;

  List<dynamic> _currentAttendanceData = [];
  String currectDateLoginTime = '';
  String currentBreakStartTime = '';
  String currentBreakCompletionTime = '';
  String currentLogoutTime = '';
  String _swipeDirectionIS = '';
  bool _isBreakStart = false;
  bool _isBreakEnd = false;
  bool _isLoading = false;

  String employeeId = '';
  String attendanceId = '';
  String updateField = '';
  String dutyLocation = '';
  String latitude = '';
  String longitude = '';

  @override
  void initState() {
    super.initState();
    _setSelectvalue();
    fetchAttendance();
    _loadSavedCredentials();
  }



  Future<void> fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void fetchAttendance() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _currentAttendanceData = widget.currentAttendanceDatais;
      attendanceId = _currentAttendanceData[0]['id'].toString();
      currectDateLoginTime =
          (_currentAttendanceData[0]['login_time'] ?? '').toString();
      currentBreakStartTime =
          (_currentAttendanceData[0]['break_start_time'] ?? '').toString();
      currentBreakCompletionTime =
          (_currentAttendanceData[0]['break_completion_time'] ?? '').toString();
      currentLogoutTime =
          (_currentAttendanceData[0]['logout_time'] ?? '').toString();
    });
    print(
        'Current date login time: ${_currentAttendanceData[0]['login_time']}');
  }

  // Get local storage data
  Future<void> _setSelectvalue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? savedSelectWorkLocation =
        prefs.getBool('_isSelectWorkLocation');
    final bool? savedSelectBreakStart = prefs.getBool('_isSelectBreakStart');
    final bool? savedSelectBreakComplete =
        prefs.getBool('_isSelectBreakComplete');
    final bool? savedSelectPunchOut = prefs.getBool('_isSelectPunchOut');

    setState(() {
      _isSelectWorkLocation = savedSelectWorkLocation ?? false;
      _isSelectBreakStart = savedSelectBreakStart ?? false;
      _isSelectBreakComplete = savedSelectBreakComplete ?? false;
      _isSelectPunchOut = savedSelectPunchOut ?? false;
    });
  }

  //  SharedPreferences and update the local variable
  Future<void> _updateLocalStorage(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Set local storage data
  Future<void> _resetSelectValue() async {
    await Future.delayed(Duration(seconds: 10));
    await _updateLocalStorage('_isSelectWorkLocation', false);
    await _updateLocalStorage('_isSelectBreakStart', false);
    await _updateLocalStorage('_isSelectBreakComplete', false);
    await _updateLocalStorage('_isSelectPunchOut', false);
  }

  _handleSwipeCompletion() async {
 
    fetchLocation();
    if (_xOffset.abs() > _swipeThreshold || _yOffset.abs() > _swipeThreshold) {
      if (currectDateLoginTime.isEmpty) {
        await _updateLocalStorage('_isSelectWorkLocation', true);
        _isSelectWorkLocation = true;
        _swipeDirectionIS = _yOffset > 0 ? 'client' : 'pwc';
        setState(() {
          dutyLocation = _swipeDirectionIS;
        });
      } else if (currectDateLoginTime.isNotEmpty &&
          currentBreakStartTime.isEmpty) {
        await _updateLocalStorage('_isSelectBreakStart', true);
        _isSelectBreakStart = true;

        _swipeDirectionIS = _xOffset > 0 ? 'skip_next' : 'break_start_time';
        setState(() {
          updateField = _swipeDirectionIS;
        });
      } else if (currectDateLoginTime.isNotEmpty &&
          currentBreakStartTime.isNotEmpty &&
          currentBreakCompletionTime.isEmpty) {
        await _updateLocalStorage('_isSelectBreakComplete', true);
        _isSelectBreakComplete = true;

        _swipeDirectionIS =
            _xOffset > 0 ? 'skip_next' : 'break_completion_time';
        setState(() {
          updateField = _swipeDirectionIS;
        });
      } else {
        await _updateLocalStorage('_isSelectPunchOut', true);
        _isSelectPunchOut = true;
        _swipeDirectionIS = _yOffset > 0 ? 'logout_time' : '';
        setState(() {
          updateField = _swipeDirectionIS;
        });
        _resetSelectValue();
      }

      print('Swipe Direction: $_swipeDirectionIS');
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

  Future<void> _loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? Employee_Id = prefs.getString('Employee_Id');

    print("Emp_Id:$Employee_Id");

    setState(() {
      employeeId = Employee_Id ?? '';
    });
  }

  void submitAttendance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // String employeeId = "126";
      // String updateField = "break_start_time";
      // String dutyLocation = "Home";
      // String attendanceId = "34603";
      // String latitude = "12.971598";
      // String longitude = "77.594566";

      POST_API postApi = POST_API();
      Map<String, dynamic> result = await postApi.attendance(
        employee_id: employeeId,
        update_field: updateField,
        duty_location: dutyLocation,
        attendance_id: attendanceId,
        latitude: latitude,
        longitude: longitude,
      );

      if (result['status'] == true) {
        print("Attendance marked successfully: ${result['message']}");
      } else {
        print("Failed to mark attendance: ${result['message']}");
      }
    } catch (e) {
      print("Error during attendance API call: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

          // if (_swipeDirection == 'horizontal') {
          //   _xOffset += details.delta.dx;
          //   _yOffset += details.delta.dy;
          // } else if (_swipeDirection == 'vertical') {
          //   _xOffset += details.delta.dx;
          //   _yOffset += details.delta.dy;
          // }

          if (currectDateLoginTime.isEmpty) {
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
        await _handleSwipeCompletion(); // Call the reusable function
        _resetPosition(); // Reset position after completion
      },
      child: Stack(
        children: [
          if (currectDateLoginTime.isEmpty) _buildSelectWorkLocation(context),
          if (currectDateLoginTime.isNotEmpty &&
                  currentBreakStartTime.isEmpty ||
              _isBreakStart)
            _buildBreakStart(context),
          if (currectDateLoginTime.isNotEmpty &&
              currentBreakStartTime.isNotEmpty &&
              currentBreakCompletionTime.isEmpty)
            _buildBreakComplete(context),
          if (currectDateLoginTime.isNotEmpty &&
              currentBreakStartTime.isNotEmpty &&
              currentBreakCompletionTime.isNotEmpty &&
              currentLogoutTime.isEmpty)
            _buildPunchOut(context),
          if (currentLogoutTime.isNotEmpty) _finalDone(context),
        ],
      ),
    );
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
              isHighlighted: _swipeDirectionIS == 'home',
            ),
            _buildSwipeControl(),
            _buildIcon(
              iconPath: 'assets/images/office.svg',
              isHighlighted: _swipeDirectionIS == 'office',
            ),
          ],
        ),
        _buildIcon(
          iconPath: 'assets/images/client.svg',
          isHighlighted: _swipeDirectionIS == 'client',
        ),
      ],
    );
  }

  Widget _buildBreakStart(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIcon(
          iconPath: 'assets/images/break_start.svg',
          isHighlighted: _swipeDirectionIS == 'break_start',
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
          isHighlighted: _swipeDirectionIS == 'break_complete',
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
          isHighlighted: _swipeDirectionIS == 'punch_out',
        ),
      ],
    );
  }

  Widget _finalDone(BuildContext context) {
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
