import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/utils/Screens/documentArchiveScreen.dart';
import 'package:hrms/utils/Screens/leaveScreen.dart';
import 'package:hrms/utils/Screens/loginSreen.dart';
import 'package:hrms/utils/Widget/logoutWidget.dart';

class BottamnavigationBar extends StatefulWidget {
  const BottamnavigationBar({super.key});

  @override
  State<BottamnavigationBar> createState() => _BottamnavigationBarState();
}

class _BottamnavigationBarState extends State<BottamnavigationBar> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    const Center(child: DocumentArchiveScreen()),
    // const Center(child: Attandancescreen()),
    Center(child: LeaveScreen()),
    const Center(child: Text('Logout')),
  ];

  void _pageChanges(int index) {
    setState(() {
      // if (index == 1) {
      //   // Do nothing if it's the second tab
      //   return;
      // } else
      // if (index == 3) {
      if (index == 2) {
        _showLogoutDialog();
      } else {
        _currentPage = index;
      }
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => const LogoutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.blackShade,
      bottomNavigationBar: Container(
        height: screenHeight * 0.07,
        decoration: BoxDecoration(
          color: AppColors.lightblue,
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
          animationDuration: const Duration(milliseconds: 300),
          indicatorColor: Colors.white,
          indicatorShape: const CircleBorder(),
          backgroundColor: Colors.transparent,
          destinations: [
            _buildNavItem(
              iconPath: 'assets/images/add_notes.svg',
              screenHeight: screenHeight,
            ),
            // _buildNavItem(
            //   iconPath: 'assets/images/account_balance_wallet.svg',
            //   screenHeight: screenHeight,
            // ),
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
      padding: EdgeInsets.only(top: screenHeight * 0.019),
      child: NavigationDestination(
        selectedIcon: Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: SvgPicture.asset(iconPath),
        ),
        icon: SvgPicture.asset(
          iconPath,
          height: 28,
          width: 28,
          color: Colors.black,
        ),
        label: '',
      ),
    );
  }
}
