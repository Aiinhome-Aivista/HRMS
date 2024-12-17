import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/components/CustomButton.dart';
import 'package:hrms/components/CustomFloatingButton.dart';
import 'package:hrms/components/TransparentPageRoute.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/utils/Screens/attandanceScreen.dart';
import 'package:intl/intl.dart';

class LeaveScreen extends StatefulWidget {
  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  String? selectedLeaveType;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController causesController = TextEditingController();

  bool get isFormValid {
    return selectedLeaveType != null &&
        startDate != null &&
        endDate != null &&
        causesController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Leave',
            style: HeaderFontStyle.style,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
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
                hintText: 'Supriti Pal',
                isReadOnly: true,
              ),
              SizedBox(height: 20),
              _buildInputField(
                icon: Icons.hotel,
                hintText: 'Leave type',
                isDropdown: true,
              ),
              SizedBox(height: 20),
              _buildDateField(
                icon: Icons.calendar_month,
                hintText: startDate == null
                    ? 'Leave start'
                    : DateFormat('dd/MM/yyyy').format(startDate!),
                onTap: _selectStartDate,
              ),
              SizedBox(height: 20),
              _buildDateField(
                icon: Icons.calendar_month,
                hintText: endDate == null
                    ? 'Leave end'
                    : DateFormat('dd/MM/yyyy').format(endDate!),
                onTap: _selectEndDate,
              ),
              SizedBox(height: 20),
              _buildInputField(
                hintText: '     Causes...',
                maxLines: 4,
                causesController: causesController,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  buttonText: 'Apply',
                  onPressed: isFormValid
                      ? () {
                          print("apply leave");
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

  Widget _buildDateField({
    required IconData icon,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.lightblue,
            width: 1,
          ),
        ),
        child: Row(
          children: [
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
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: leaveFontStyle.style,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
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
            SizedBox(width: 12),
          ],
          Expanded(
            child: isDropdown
                ? DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: leaveFontStyle.style,
                      border: InputBorder.none,
                    ),
                    value: selectedLeaveType,
                    items: <String>['Half day', 'Full day'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: leaveFontStyle.style,
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
                      hintStyle: leaveFontStyle.style,
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
