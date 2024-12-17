import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/utils/Widget/dateDisplay.dart';

class Attandancescreen extends StatefulWidget {
  const Attandancescreen({super.key});

  @override
  State<Attandancescreen> createState() => _AttandancescreenState();
}

class _AttandancescreenState extends State<Attandancescreen> {
  double _xOffset = 0;
  double _yOffset = 0;

  // The distance threshold to consider it as a "swipe"
  final double _swipeThreshold = 50.0;

  // Lock the swipe direction
  String? _swipeDirection; // 'horizontal' or 'vertical'

  // Limits for the swipe movement based on icon positions
  double _leftLimit = 0;
  double _rightLimit = 0;
  double _topLimit = 0;
  double _bottomLimit = 0;
  late String _swipeDirectionIS = '';

  // Calendar-related variables
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  // Method to reset positionn
  void _resetPosition() {
    setState(() {
      _xOffset = 0;
      _yOffset = 0;
      _swipeDirection = null;
    });
  }

//========================================= UI =======================================
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Icon position offsets and swipe button size
    const double buttonSize = 80.0;

    // Calculate limits based on icon positions
    _leftLimit = -(screenWidth * 0.1 +
        buttonSize / 2); // Left limit based on the left icon
    _rightLimit = screenWidth * 0.1 +
        buttonSize / 2; // Right limit based on the right icon
    _topLimit = -(screenHeight * 0.2 -
        buttonSize * 1.5); // Top limit based on the up icon
    _bottomLimit = screenHeight * 0.2 -
        buttonSize * 1.5; // Bottom limit based on the down icon

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      // backgroundColor: const Color.fromRGBO(8, 12, 17, 1),
      body: GestureDetector(
        onPanStart: (details) {
          _swipeDirection = null; // Reset swipe direction on new swipe
        },
        onPanUpdate: (details) {
          setState(() {
            if (_swipeDirection == null) {
              // Decide the swipe direction (horizontal or vertical)
              if (details.delta.dx.abs() > details.delta.dy.abs()) {
                _swipeDirection = 'horizontal';
              } else {
                _swipeDirection = 'vertical';
              }
            }

            // Restrict movement based on the determined swipe direction
            if (_swipeDirection == 'horizontal') {
              _xOffset += details.delta.dx;
              // Restrict the horizontal movement within limits
              if (_xOffset < _leftLimit) _xOffset = _leftLimit;
              if (_xOffset > _rightLimit) _xOffset = _rightLimit;
              _yOffset = 0; // Lock vertical movement
            } else if (_swipeDirection == 'vertical') {
              _yOffset += details.delta.dy;
              // Restrict the vertical movement within limits
              if (_yOffset < _topLimit) _yOffset = _topLimit;
              if (_yOffset > _bottomLimit) _yOffset = _bottomLimit;
              _xOffset = 0; // Lock horizontal movement
            }
          });
        },
        onPanEnd: (details) {
          // Detect swipe direction based on the offset
          if (_xOffset.abs() > _swipeThreshold ||
              _yOffset.abs() > _swipeThreshold) {
            if (_xOffset.abs() > _yOffset.abs()) {
              if (_xOffset > 0) {
                print('Swiped OFFICE');
                setState(() {
                  _swipeDirectionIS = 'office';
                });
                print('_swipeDirectionIS : $_swipeDirectionIS');
              } else {
                print('Swiped HOME');
                setState(() {
                  _swipeDirectionIS = 'home';
                });
              }
            } else {
              if (_yOffset > 0) {
                print('Swiped CLIENT');
                setState(() {
                  _swipeDirectionIS = 'client';
                });
              } else {
                print('Swiped PWC');
                setState(() {
                  _swipeDirectionIS = 'pwc';
                });
              }
            }
          }
          // Reset position after swipe
          _resetPosition();
        },
        child: Stack(
          children: [
            // Upper section with Text and Calendar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 45, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Center "Attendance" text
                        Expanded(
                          child: Center(
                            child: Text(
                              'Attendance',
                              style: HeaderFontStyle.style,
                            ),
                          ),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.lightblue,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // DateDisplay below the Row
                    DateDisplay(selectedDay: _selectedDay),
                  ],
                ),
              ),
            ),

            // Up icon
            _buildIcon(
              top: screenHeight * 0.59,
              left: (screenWidth / 2) - 55,
              iconPath: 'assets/images/pwc.svg',
              isHighlighted: _swipeDirectionIS == 'pwc',
            ),
            // Down icon
            _buildIcon(
              bottom: screenHeight * 0.11,
              left: (screenWidth / 2) - 50,
              iconPath: 'assets/images/client.svg',
              isHighlighted: _swipeDirectionIS == 'client',
            ),
            // Left icon
            _buildIcon(
              left: screenWidth * 0.05,
              top: (screenHeight / 2) + 190,
              iconPath: 'assets/images/home.svg',
              isHighlighted: _swipeDirectionIS == 'home',
            ),
            // Right icon
            _buildIcon(
              right: screenWidth * 0.05,
              top: (screenHeight / 2) + 190,
              iconPath: 'assets/images/office.svg',
              isHighlighted: _swipeDirectionIS == 'office',
            ),
            // The actual swipe button
            Padding(
              padding: const EdgeInsets.only(top: 420),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(_xOffset, _yOffset, 0),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/swip.svg',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required String iconPath,
    required bool isHighlighted,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isHighlighted ? Colors.white : AppColors.greyShade2,
          BlendMode.srcIn,
        ),
        child: SvgPicture.asset(
          iconPath,
        ),
      ),
    );
  }
}
