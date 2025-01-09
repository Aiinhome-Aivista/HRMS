import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/Services/api_services.dart';
import 'package:hrms/components/CustomFloatingButton.dart';
import 'package:hrms/components/TransparentPageRoute.dart';
import 'package:hrms/components/donutChart.dart';
import 'package:hrms/components/loading_spinner.dart';
import 'package:hrms/components/showLeaveDays.dart';
import 'package:hrms/components/workingHoursGraph.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

    // //print('Login Successful gateUserName: $gateUserName');
    // //print('Login Successful gateUserEmail: $gateUserEmail');
    // //print('Login Successful employeeId: $employeeId');

    // //print("empId:$employeeId");

    setState(() {
      userName = gateUserName ?? '';
      userEmail = gateUserEmail ?? '';
      empId = employeeId ?? '';
    });
    if (empId.isNotEmpty) {
      await noticeFetch();
    }
  }

// notice fetch
  Future<void> noticeFetch() async {
    if (empId.isEmpty) {
      // //print('empId is empty');
      return;
    }

    setState(() {});

    try {
      POST_API postApi = POST_API();
      Map<String, dynamic> response = await postApi.notice(empId);

      setState(() {});

      if (response['status'] == true) {
        notices = List<String>.from(response['data']);
        // //print("notice data fetch:$notices");
        setState(() {}); // Update the UI
      } else {
        // //print('Error: ${response['msg']}');
      }
    } catch (e) {
      setState(() {});
      // //print('Error: $e');
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
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HRMS',
                style: HeaderFontStyle.style,
              ),
              GestureDetector(
                  onTap: () {
                    // Add your notification icon click functionality here
                  },
                  child: SvgPicture.asset(
                    'assets/images/Notifications.svg',
                    width: 24.0,
                    height: 24.0,
                  )),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //notice
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (notices.isNotEmpty)
                  CarouselSlider(
                    items: notices.map((notice) {
                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Card(
                          color: AppColors.unselectedNavBarColor,
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
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 150,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 0.9,
                      initialPage: 0,
                      enlargeFactor: 0.1,
                    ),
                  )
                else
                  CarouselSlider(
                    items: [
                      Builder(
                        builder: (BuildContext context) {
                          return Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                              decoration: BoxDecoration(
                                color: AppColors.blackShade,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const LoadingSpinner());
                        },
                      ),
                    ],
                    options: CarouselOptions(
                      height: 150.0,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 1.0,
                      initialPage: 0,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 4,
                  child: DynamicDonutChart(),
                ),
                SizedBox(width: 2),
                Flexible(
                  flex: 2,
                  child: LeaveDaysShow(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const WorkingHoursGraph()
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
