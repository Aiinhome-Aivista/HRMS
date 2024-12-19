import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/styleColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceStart extends StatefulWidget {
  const AttendanceStart({super.key});

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
  String _swipeDirectionIS = '';

  String? _swipeDirection;
  double _leftLimit = 0;
  double _rightLimit = 0;
  double _topLimit = 0;
  double _bottomLimit = 0;

  @override
  void initState() {
    super.initState();
    _setSelectvalue();
    
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
    if (_xOffset.abs() > _swipeThreshold || _yOffset.abs() > _swipeThreshold) {
      if (!_isSelectWorkLocation) {
        await _updateLocalStorage('_isSelectWorkLocation', true);
        _isSelectWorkLocation = true;
        _swipeDirectionIS = _yOffset > 0 ? 'client' : 'pwc';
      } else if (!_isSelectBreakStart) {
        await _updateLocalStorage('_isSelectBreakStart', true);
        _isSelectBreakStart = true;
        _swipeDirectionIS = _xOffset > 0 ? 'break_start' : 'skip_next';
      } else if (!_isSelectBreakComplete) {
        await _updateLocalStorage('_isSelectBreakComplete', true);
        _isSelectBreakComplete = true;
        _swipeDirectionIS = _xOffset > 0 ? 'break_complete' : 'skip_next';
      } else {
        await _updateLocalStorage('_isSelectPunchOut', true);
        _isSelectPunchOut = true;
        _swipeDirectionIS = _yOffset > 0 ? 'punch_out' : '';
        _resetSelectValue();
      }
    }
  }

  void _resetPosition() {
    setState(() {
      _xOffset = 0;
      _yOffset = 0;
      _swipeDirection = null;
    });
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

          if (!_isSelectWorkLocation) {
            if (_swipeDirection == 'horizontal') {
              _xOffset += details.delta.dx;
              _yOffset = 0;
            } else if (_swipeDirection == 'vertical') {
              _yOffset += details.delta.dy;
              _xOffset = 0;
            }
          } else if (!_isSelectBreakStart) {
            _yOffset = 0;
            _xOffset += details.delta.dx;
          } else if (!_isSelectBreakComplete) {
            _yOffset = 0;
            _xOffset += details.delta.dx;
          } else if (!_isSelectPunchOut) {
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
          if (!_isSelectWorkLocation) _buildSelectWorkLocation(context),
          if (_isSelectWorkLocation && !_isSelectBreakStart)
            _buildBreakStart(context),
          if (_isSelectWorkLocation &&
              _isSelectBreakStart &&
              !_isSelectBreakComplete)
            _buildBreakComplete(context),
          if (_isSelectWorkLocation &&
              _isSelectBreakStart &&
              _isSelectBreakComplete &&
              !_isSelectPunchOut)
            _buildPunchOut(context),
          if (_isSelectPunchOut) _finalDone(context),
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
        _buildIcon(
          iconPath: '',
          isHighlighted: _swipeDirectionIS == '',
        ),
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
