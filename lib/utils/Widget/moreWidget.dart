import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/utils/Screens/loginSreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';

class Morewidget extends StatefulWidget {
  const Morewidget({super.key});

  @override
  State<Morewidget> createState() => _MorewidgetState();
}

class _MorewidgetState extends State<Morewidget> {
  String userName = '';
  String userEmail = '';
  String empId = '';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Get local storage data
  Future<void> _loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? gateUserName = prefs.getString('SaveUserName');
    final String? gateUserEmail = prefs.getString('SaveUserEmail');
    final String? employeeId = prefs.getString('employeeId');

    print('Login Successful gateUserName: $gateUserName');
    print('Login Successful gateUserEmail: $gateUserEmail');
    print('Login Successful employeeId: $employeeId');

    print("empId:$employeeId");

    setState(() {
      userName = gateUserName ?? '';
      userEmail = gateUserEmail ?? '';
      empId = employeeId ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 20,
            right:20,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.25,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blackShade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.person,
                      size: 50, color: AppColors.lightblue),
                  const SizedBox(height: 8),
                  Text(
                    userName,
                    style: const TextStyle(
                        color: AppColors.lightblue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userEmail,
                    style: docArchiveFontStyle.style,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('265', 'Attendance'),
                      _buildStatItem('50', 'Credit Score'),
                      _buildStatItem('13', 'Leave'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 65,
                child: SliderButton(
                  action: () async {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false, // Removes all previous routes
                    );
                    return null;
                  },
                  label: const Text(
                    "Slide to log out",
                    style: TextStyle(
                      color: Color(0xff4a4a4a),
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  icon: const Center(
                    child: Icon(
                      CupertinoIcons.power,
                      color: Colors.redAccent,
                      size: 30.0,
                      semanticLabel:
                          'Text to announce in accessibility modes',
                    ),
                  ),
                  boxShadow: BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: docArchiveNumStyle.style),
        Text(
          label,
          style: docArchiveFontStyle.style,
        ),
      ],
    );
  }
}
