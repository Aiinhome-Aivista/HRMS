import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms/Services/api_services.dart';
import 'package:hrms/components/CustomFloatingButton.dart';
import 'package:hrms/components/TransparentPageRoute.dart';
import 'package:hrms/components/loading_spinner.dart';
import 'package:hrms/components/showToast.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentArchiveScreen extends StatefulWidget {
  const DocumentArchiveScreen({super.key});

  @override
  State<DocumentArchiveScreen> createState() => _DocumentArchiveScreenState();
}

class _DocumentArchiveScreenState extends State<DocumentArchiveScreen> {
  String userName = '';
  String userEmail = '';
  String Emp_Id = '';
  String latitude = '';
  String longitude = '';
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool _isLoading = false;
  List<dynamic> notices = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    updateLocation();
  }

  // Get local storage data
  Future<void> _loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? gateUserName = prefs.getString('SaveUserName');
    final String? gateUserEmail = prefs.getString('SaveUserEmail');
    final String? Employee_Id = prefs.getString('Employee_Id');

    print("Emp_Id:$Employee_Id");

    setState(() {
      userName = gateUserName ?? '';
      userEmail = gateUserEmail ?? '';
      Emp_Id = Employee_Id ?? '';
    });
    if (Emp_Id.isNotEmpty) {
      await noticeFetch();
    }
  }

//fetch latitude longitude
  Future<void> fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

//location update
  void updateLocation() async {
    fetchLocation();
    try {
      POST_API postApi = POST_API();
      Map<String, dynamic> response =
          await postApi.locationUpdate(Emp_Id, latitude, longitude, date);

      if (response['status'] == true) {
        print("Location update successful: ${response['message']}");
      } else {
        print("Location update failed: ${response['message']}");
      }
    } catch (e) {
      print("Error calling locationUpdate API: $e");
    }

    Future.delayed(Duration(hours: 1), () {
      updateLocation();
    });
  }

// notice fetch
  Future<void> noticeFetch() async {
    if (Emp_Id.isEmpty) {
      print('Emp_Id is empty');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      POST_API postApi = POST_API();
      Map<String, dynamic> response = await postApi.notice(Emp_Id);

      setState(() {
        _isLoading = false;
      });

      if (response['status'] == true) {
        notices = List<String>.from(response['data']);
        print("notice data fetch:$notices");
        setState(() {}); // Update the UI
      } else {
        print('Error: ${response['msg']}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Document Archive',
            style: HeaderFontStyle.style,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
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
            const SizedBox(height: 16),
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
                          color: AppColors.blackShade,
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
                      // enlargeCenterPage: true,
                      autoPlay: false,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 0.9,
                      initialPage: 0,
                      enlargeFactor: 0.2,
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
                              child: LoadingSpinner());
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

            // Options List
            Expanded(
              child: ListView(
                children: [
                  _buildOptionTile('Offer Later'),
                  const SizedBox(height: 10),
                  _buildOptionTile('Account Statement'),
                  const SizedBox(height: 10),
                  _buildOptionTile('Documents'),
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

  Widget _buildOptionTile(String title) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blackShade,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        title: Text(
          title,
          style: docArchiveFontStyle.style,
        ),
        trailing: const Icon(Icons.visibility, color: AppColors.lightblue),
        onTap: () {},
      ),
    );
  }
}
