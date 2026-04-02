import 'package:flutter/material.dart';
import 'package:hrms/Services/sessionManager.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/utils/Screens/loginSreen.dart';
import 'package:hrms/utils/Widget/logoutConfirmation.dart';
import 'package:hrms/utils/Widget/reminderWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String userName = '';
  String userEmail = '';
  String empId = '';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final String? gateUserName = prefs.getString('SaveUserName');
    final String? gateUserEmail = prefs.getString('SaveUserEmail');
    final String? employeeId = prefs.getString('employeeId');

    if (!mounted) return;

    setState(() {
      userName = gateUserName ?? '';
      userEmail = gateUserEmail ?? '';
      empId = employeeId ?? '';
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LogoutConfirmDialog(
          onCancel: () {},
          onConfirm: () async {
            await SessionManager.logout();

            if (!mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
              (route) => false,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ✅ HRMS-style centered header
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      "Settings",
                      style: HeaderFontStyle.style,
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 👤 USER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.unselectedNavBarColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color.fromRGBO(247, 244, 247, 1),
                      radius: 20,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: AppColors.lightblue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName.isNotEmpty ? userName : 'No Username',
                            style: const TextStyle(
                              color: AppColors.lightblue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Email : ${userEmail.isNotEmpty ? userEmail : 'No Email'}",
                            style: docArchiveFontStyle.style,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔔 REMINDER — wrapped to apply background color
              Container(
                decoration: BoxDecoration(
                  color: AppColors.unselectedNavBarColor, // ← match profile card color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const ReminderWidget(),
              ),

              const SizedBox(height: 24),

              // 🔥 LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // ← changed from redAccent
                    foregroundColor: Colors.white,                // ← icon & text in red
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.redAccent), // ← red border outline
                    ),
                  ),
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}