import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/utils/Screens/activityScreen.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:hrms/utils/Screens/leaveScreen.dart';

class BottamnavigationBar extends StatefulWidget {
  const BottamnavigationBar({Key? key}) : super(key: key);

  @override
  State<BottamnavigationBar> createState() => _BottamnavigationBarState();
}

class _BottamnavigationBarState extends State<BottamnavigationBar> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    const Center(child: Activityscreen()),
    const Center(child: Attandancescreen()),
    Center(child: LeaveScreen()),
    const Center(child: Text('Logout')),
  ];

  void _pageChanges(int index) {
    setState(() {
      if (index == 3) {
        _showLogoutDialog();
      } else {
        _currentPage = index;
      }
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Implement logout logic here
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  final double screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    bottomNavigationBar: Container(
      height: screenHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.red, // Change this to your desired background color
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(2, 0),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _currentPage,
        onDestinationSelected: _pageChanges,
        indicatorColor: Color.fromRGBO(143, 181, 255, 1),
        backgroundColor: Colors.white,
        destinations: [
          _buildNavItem(
            iconPath: 'assets/images/add_notes.svg',
            screenHeight: screenHeight,
          ),
          _buildNavItem(
            iconPath: 'assets/images/account_balance_wallet.svg',
            screenHeight: screenHeight,
          ),
          _buildNavItem(
            iconPath: 'assets/images/attendance.svg',
            screenHeight: screenHeight,
          ),
          _buildNavItem(
            iconPath: 'assets/images/logout.svg',
            screenHeight: screenHeight,
          ),
        ],
      ),
    ),
    body: _pages[_currentPage],
  );
}


  Widget _buildNavItem({
    required String iconPath,
    required double screenHeight,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.005),
      child: NavigationDestination(
        selectedIcon: SvgPicture.asset(iconPath, height: 22, width: 22),
        icon: SvgPicture.asset(
          iconPath,
          height: 20,
          width: 20,
          color: Colors.black,
        ),
        label: '',
      ),
    );
  }
}
