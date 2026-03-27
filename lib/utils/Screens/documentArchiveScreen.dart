import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/Services/api_services.dart';
import 'package:hrms/components/CustomFloatingButton.dart';
import 'package:hrms/components/TransparentPageRoute.dart';
import 'package:hrms/components/addSkills%20.dart';
import 'package:hrms/components/donutChart.dart';
import 'package:hrms/components/loading_spinner.dart';
import 'package:hrms/components/showLeaveDays.dart';
import 'package:hrms/components/workingHoursGraph.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentArchiveScreen extends StatefulWidget {
  const DocumentArchiveScreen({super.key});

  @override
  State<DocumentArchiveScreen> createState() => _DocumentArchiveScreenState();
}

class _DocumentArchiveScreenState extends State<DocumentArchiveScreen> {
  String userName = '';
  String userEmail = '';
  String empId = '';
  List<dynamic> notices = [];
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _triggerFiam();
    printInstallationId();
  }

  Future<void> printInstallationId() async {
    final id = await FirebaseInstallations.instance.getId();
    print("🔥 Installation ID: $id");
  }

  Future<void> _triggerFiam() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await FirebaseInAppMessaging.instance.triggerEvent("fiam_init");
    });
  }

  Future<void> _loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? gateUserName = prefs.getString('SaveUserName');
    final String? gateUserEmail = prefs.getString('SaveUserEmail');
    final String? employeeId = prefs.getString('employeeId');

    if (!mounted) return;

    setState(() {
      userName = gateUserName ?? '';
      userEmail = gateUserEmail ?? '';
      empId = employeeId ?? '';
    });

    if (empId.isNotEmpty) {
      await noticeFetch();
    }
  }

  Future<void> _initFiam() async {
    final fiam = FirebaseInAppMessaging.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      // Then trigger the event again
      await fiam.triggerEvent('attendance_opened');
    });
  }

  Future<void> noticeFetch() async {
    if (empId.isEmpty) return;

    if (mounted) setState(() {});

    try {
      POST_API postApi = POST_API();
      Map<String, dynamic> response = await postApi.notice(empId);

      if (!mounted) return;

      setState(() {});

      if (response['status'] == true) {
        notices = List<String>.from(response['data']);
        setState(() {});
      } else {
        print('Error: ${response['msg']}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {});
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('HRMS', style: HeaderFontStyle.style),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/images/Notifications.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: LoadingSpinner())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (notices.isNotEmpty)
                        CarouselSlider(
                          items: notices.map((notice) {
                            return Card(
                              color: AppColors.card,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  notice,
                                  style: noticeFontStyle.style,
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 150,
                            enlargeCenterPage: true,
                            autoPlay: true,
                          ),
                        )
                      else
                        const SizedBox(
                          height: 150,
                          child: Center(child: LoadingSpinner()),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(flex: 4, child: DynamicDonutChart()),
                            SizedBox(width: 2),
                            Flexible(flex: 2, child: LeaveDaysShow()),
                          ],
                        ),
                        SizedBox(height: 20),
                        WorkingHoursGraph(),
                        SizedBox(height: 20),
                        AddSkillsPage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            TransparentPageRoute.create(const AttendanceScreen()),
          );
        },
        icon: Icons.add,
      ),
    );
  }
}
