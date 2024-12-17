import 'package:flutter/material.dart';
import 'package:hrms/components/CustomFloatingButton.dart';
import 'package:hrms/components/TransparentPageRoute.dart';
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

    setState(() {
      userName = gateUserName ?? '';
      userEmail = gateUserEmail ?? '';
    });
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
                  SizedBox(height: 8),
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
            SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greyShade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From admin',
                    style: leaveFontStyle.style,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                    style: docArchiveFontStyle.style,
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Adventure Technology P.L.T',
                      style:
                          TextStyle(color: AppColors.lightblue, fontSize: 12),
                    ),
                  ),
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
            TransparentPageRoute.create(const Attandancescreen()),
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
