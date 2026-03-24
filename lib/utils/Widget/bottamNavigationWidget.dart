import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:hrms/utils/Screens/documentArchiveScreen.dart';
import 'package:hrms/utils/Screens/leaveDetails.dart';
import 'package:hrms/utils/Screens/settingScreen.dart';
import 'package:hrms/utils/Widget/moreWidget.dart';

class BottamnavigationBar extends StatefulWidget {
  const BottamnavigationBar({super.key});

  @override
  State<BottamnavigationBar> createState() => _BottamnavigationBarState();
}

class _BottamnavigationBarState extends State<BottamnavigationBar> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    const Center(child: DocumentArchiveScreen()),
    Center(
        child: Leavedetails(
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      selectedLeaveType: '',
      causes: '',
    )),
    const Center(child: SettingScreen()),
    const Center(child: Morewidget()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: _pages.elementAt(_currentPage),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: SizedBox(
          height: 100,
          child: BottomNavigationBar(
            backgroundColor: AppColors.lightblue,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/HomeSvg.svg',
                  width: 24.0,
                  height: 24.0,
                  color: _currentPage == 0
                      ? AppColors.selectedNavBarColor
                      : AppColors.unselectedNavBarColor,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/account_balance_wallet.svg',
                  width: 24.0,
                  height: 24.0,
                  color: _currentPage == 1
                      ? AppColors.selectedNavBarColor
                      : AppColors.unselectedNavBarColor,
                ),
                label: 'Activity',
              ),

              //    BottomNavigationBarItem(
              //   icon:  SvgPicture.asset(
              //     'assets/images/attendance.svg',
              //     width: 24.0,
              //     height: 24.0,
              // color: _currentPage == 0 ? AppColors.selectedNavBarColor : AppColors.unselectedNavBarColor,
              //   ),
              //   label: 'Document',
              // ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.how_to_reg,
                  ), label: "Setting"),

              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/LogoutSvg.svg',
                  width: 18.0,
                  height: 18.0,
                  color: _currentPage == 3
                      ? AppColors.selectedNavBarColor
                      : AppColors.unselectedNavBarColor,
                ),
                label: 'Logout',
              ),
            ],
            currentIndex: _currentPage,
            selectedItemColor: AppColors.selectedNavBarColor,
            unselectedItemColor: AppColors.unselectedNavBarColor,
            selectedLabelStyle: selectedNavBarTextStyle.style,
            unselectedLabelStyle: unselectedNavBarTextStyle.style,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
