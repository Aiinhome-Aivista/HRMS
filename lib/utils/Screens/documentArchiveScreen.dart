import 'package:flutter/material.dart';
import 'package:hrms/Services/api_services.dart';
import 'package:hrms/components/CustomFloatingButton.dart';
import 'package:hrms/components/TransparentPageRoute.dart';
import 'package:hrms/components/showToast.dart';
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
  String Emp_Id = '';
  bool _isLoading = false;
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

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greyShade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  notices.isNotEmpty
                      ? SizedBox(
                          height: 100,
                          child: PageView.builder(
                            itemCount: notices.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  notices[index],
                                  style: docArchiveFontStyle.style,
                                ),
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                              'No notices available.',
                              style: docArchiveFontStyle.style,
                            ),
                          ),
                        ),
                  const SizedBox(height: 8),
                ],
              ),
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
