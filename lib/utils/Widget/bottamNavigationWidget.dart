import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/utils/Screens/activityScreen.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:hrms/utils/Screens/leaveScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentPage = 0;

  final List<Map<String, dynamic>> _icons = [
    {
      'icon': 'assets/icons/HomeIconActive.png',
      'unselectedIcon': 'assets/icons/add_notes.png',
      'selectedColor': Color.fromRGBO(143, 181, 255, 1),
      'unselectedColor': const Color(0xFF3E404C),
    },
    {
      'icon': 'assets/icons/FlightIconActive.png',
      'unselectedIcon': 'assets/icons/account_balance_wallet.png',
      'selectedColor': Color.fromRGBO(143, 181, 255, 1),
      'unselectedColor': const Color(0xFF3E404C),
    },
    {
      'icon': 'assets/icons/MoreIconActive.png',
      'unselectedIcon': 'assets/icons/attendances.png',
      'selectedColor': Color.fromRGBO(143, 181, 255, 1),
      'unselectedColor': const Color(0xFF3E404C),
    },
    {
      'icon': 'assets/icons/NewIconActive.png',
      'unselectedIcon': 'assets/icons/logout.png',
      'selectedColor': Color.fromRGBO(143, 181, 255, 1),
      'unselectedColor': const Color(0xFF3E404C),
    },
  ];

  final List<Widget> _pages = [
    const Activityscreen(),
    const Attandancescreen(),
    LeaveScreen(),
    // Empty placeholder for 4th tab, as it won't navigate to a new page
    Container(),
  ];

  void _pageChanges(int index) {
    setState(() {
      if (_currentPage != 3 && index == 3) {
        _showLogoutDialog();
      } else {
        _currentPage = index;
      }
    });
  }

  // Function to show logout dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Handle logout action here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle actual logout logic here
                Navigator.of(context).pop(); // Close the dialog
                // You can implement actual logout here, like clearing session or redirecting to login screen
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        if (currentPageIndex != 0) {
          print("Back button pressed in Flight Thamim Screen");
          setState(() {
            currentPageIndex = 0;
            _pageChanges(0);
          });

          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(143, 181, 255, 1),
        bottomNavigationBar: Container(
          height: screenHeight * 0.11,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(75, 0, 0, 0).withOpacity(0.1),
                offset: const Offset(2, 0),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
                _pageChanges(index);
              });
            },
            indicatorColor: const Color.fromRGBO(142, 39, 143, 0.15),
            selectedIndex: currentPageIndex,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            surfaceTintColor: Colors.white,
            shadowColor: const Color.fromARGB(255, 255, 0, 0),
            elevation: 1,
            destinations: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.008),
                child: NavigationDestination(
                  selectedIcon: SvgPicture.asset(
                    'assets/icons/AppIconSVG/homeSelect.svg',
                    height: 22,
                    width: 22,
                  ),
                  icon: SvgPicture.asset(
                    'assets/icons/AppIconSVG/home.svg',
                    height: 20,
                    width: 20,
                  ),
                  label: 'Home',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.005),
                child: NavigationDestination(
                  selectedIcon: SvgPicture.asset(
                      'assets/icons/AppIconSVG/flightSelect.svg'),
                  icon: SvgPicture.asset('assets/icons/AppIconSVG/flight.svg'),
                  label: 'Flights',
                ),
              ),
              GestureDetector(
                onTap: () {
                  _pageChanges(2);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 7),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/AppIconSVG/menu.svg',
                                height: 18),
                            const SizedBox(
                              height: 9,
                            ),
                            const Text(
                              "Menu",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(62, 64, 72, 1)),
                            )
                          ]),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.005),
                child: NavigationDestination(
                  selectedIcon: SvgPicture.asset(
                      'assets/icons/AppIconSVG/newSelect.svg'), // Selected icon for 4th tab
                  icon: SvgPicture.asset(
                      'assets/icons/AppIconSVG/new.svg'), // Unselected icon for 4th tab
                  label: 'New', // Label for 4th tab
                ),
              ),
            ],
          ),
        ),
        body: _pages[_currentPage],
      ),
    );
  }
}
