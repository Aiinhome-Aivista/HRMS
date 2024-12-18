import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/components/CustomButton.dart';
import 'package:hrms/components/CustomFloatingButton.dart';
import 'package:hrms/components/DatePickerField.dart';
import 'package:hrms/components/TransparentPageRoute.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:hrms/utils/Screens/leaveDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Leaveapplyscreen extends StatefulWidget {
  @override
  _LeaveapplyscreenState createState() => _LeaveapplyscreenState();
}

class _LeaveapplyscreenState extends State<Leaveapplyscreen> {
  String? selectedLeaveType;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController causesController = TextEditingController();
  String userName = '';

  bool get isFormValid {
    return selectedLeaveType != null &&
        startDate != null &&
        endDate != null &&
        causesController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _savedCredentials();
  }

  // Get local storage data
  Future<void> _savedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? gateUserName = prefs.getString('SaveUserName');

    setState(() {
      userName = gateUserName ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 4,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/arrow.svg',
            width: 22,
            height: 22,
          ),
          onPressed: () {},
        ),
        title: Text(
          'Leave Apply',
          style: HeaderFontStyle.style,
        ),
        centerTitle: false,
        titleSpacing: -5,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                icon: Icons.person,
                hintText: userName,
                isReadOnly: true,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                icon: Icons.hotel,
                hintText: 'Leave type',
                isDropdown: true,
              ),
              const SizedBox(height: 20),
              DatePickerField(
                icon: Icons.calendar_month,
                label: 'Leave start',
                onDateSelected: (date) {
                  setState(() {
                    startDate = date;
                  });
                },
              ),
              const SizedBox(height: 20),
              DatePickerField(
                icon: Icons.calendar_month,
                label: 'Leave end',
                onDateSelected: (date) {
                  setState(() {
                    endDate = date;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildInputField(
                hintText: '     Causes...',
                maxLines: 4,
                causesController: causesController,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  buttonText: 'Apply',
                  borderRadius: BorderRadius.circular(12),
                  onPressed: isFormValid
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Leavedetails(
                                startDate: startDate ?? DateTime.now(),
                                endDate: endDate ?? DateTime.now(),
                                selectedLeaveType: selectedLeaveType ?? '',
                                causes: causesController.text,
                              ),
                            ),
                          );
                        }
                      : () {},
                  backgroundColor:
                      isFormValid ? AppColors.lightblue : AppColors.greyShade2,
                ),
              ),
            ],
          ),
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

  Widget _buildInputField({
    IconData? icon,
    required String hintText,
    bool isDropdown = false,
    bool isReadOnly = false,
    int maxLines = 1,
    Color borderColor = AppColors.lightblue,
    TextEditingController? causesController,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.lightblue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: isDropdown
                ? DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: LeaveFontStyle.style,
                      border: InputBorder.none,
                    ),
                    value: selectedLeaveType,
                    items: <String>['Half day', 'Full day'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: LeaveFontStyle.style,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLeaveType = newValue;
                      });
                    },
                  )
                : TextField(
                    controller: causesController,
                    readOnly: isReadOnly,
                    maxLines: hintText == 'Causes...' ? 4 : maxLines,
                    style: const TextStyle(color: AppColors.lightblue),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: LeaveFontStyle.style,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
