import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/components/CustomFloatingButton.dart';
import 'package:hrms/components/TransparentPageRoute.dart';
import 'package:hrms/components/leaveEventCard.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:hrms/utils/Screens/leaveApplyScreen.dart';
import 'package:intl/intl.dart';

class Leavedetails extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String selectedLeaveType;
  final String causes;

  const Leavedetails({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedLeaveType,
    required this.causes,
  });

  @override
  State<Leavedetails> createState() => _LeavedetailsState();
}

class _LeavedetailsState extends State<Leavedetails> {
  final List<dynamic> leaveValues = [
    {
      "leaveType": "Full Day",
      "startDate": "2024-12-25",
      "endDate": "2024-12-30",
      "leaveStatus": "Approved",
      "causes": "Family vacation planned for Christmas holidays.",
    },
    {
      "leaveType": "Half Day",
      "startDate": "2024-12-31",
      "endDate": "2024-12-31",
      "leaveStatus": "Pending",
      "causes": "Personal work requiring half a day.",
    },
    {
      "leaveType": "Full Day",
      "startDate": "2025-01-05",
      "endDate": "2025-01-05",
      "leaveStatus": "Approved",
      "causes": "Attending a family function.",
    },
    {
      "leaveType": "Half Day",
      "startDate": "2025-01-10",
      "endDate": "2025-01-10",
      "leaveStatus": "Cancelled",
      "causes": "Request withdrawn due to schedule change.",
    },
    {
      "leaveType": "Full Day",
      "startDate": "2025-02-15",
      "endDate": "2025-02-17",
      "leaveStatus": "Pending",
      "causes": "Medical leave awaiting approval.",
    },
    {
      "leaveType": "Half Day",
      "startDate": "2025-03-22",
      "endDate": "2025-03-22",
      "leaveStatus": "Approved",
      "causes": "Bank-related work scheduled in the afternoon.",
    },
    {
      "leaveType": "Full Day",
      "startDate": "2025-04-01",
      "endDate": "2025-04-03",
      "leaveStatus": "Approved",
      "causes": "Official training program attendance.",
    },
    {
      "leaveType": "Half Day",
      "startDate": "2025-05-12",
      "endDate": "2025-05-12",
      "leaveStatus": "Pending",
      "causes": "Half-day leave for attending a seminar.",
    },
    {
      "leaveType": "Half Day",
      "startDate": "2025-05-12",
      "endDate": "2025-05-12",
      "leaveStatus": "Pending",
      "causes": "Half-day leave for attending a seminar.",
    },
    {
      "leaveType": "Half Day",
      "startDate": "2025-05-12",
      "endDate": "2025-05-12",
      "leaveStatus": "Pending",
      "causes": "Half-day leave for attending a seminar.",
    },
    {
      "leaveType": "Half Day",
      "startDate": "2025-05-12",
      "endDate": "2025-05-12",
      "leaveStatus": "Pending",
      "causes": "Half-day leave for attending a seminar.",
    },
  ];

  bool isAscending = true;
  DateTime? selectedDate;
  String? selectedDateText;
  bool showAll = false;

  @override
  void initState() {
    super.initState();
    _resetFilters();
  }

  Future<void> _onRefresh() async {
    // Reset filters and refresh the page
    _resetFilters();
  }

  void _resetFilters() {
    setState(() {
      selectedDate = null;
      selectedDateText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarIconBrightness: Brightness.light),
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 4,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: Text('Manage Leave', style: HeaderFontStyle.style),
        centerTitle: true,
        titleSpacing: 5,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            children: [
              _buildSortAndFilterRow(),
              const SizedBox(height: 12),
              _buildLeaveList(),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            TransparentPageRoute.create(const Leaveapplyscreen()),
          );
        },
        icon: Icons.add,
      ),
    );
  }

  Widget _buildSortAndFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(
            text: selectedDateText ?? 'Filter by Date',
            icon: null,
            onTap: _selectDate,
          ),
          _buildButton(
            text: null,
            icon: Icons.swap_vert,
            onTap: _toggleSortOrder,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({String? text, IconData? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.lightblue, width: 1),
        ),
        child: Row(
          children: [
            if (icon != null) Icon(icon, size: 18, color: AppColors.lightblue),
            if (text != null)
              Text(text,
                  style: const TextStyle(
                      color: AppColors.lightblue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveList() {
    // Filter leaveValues based on the selected date
    List<dynamic> filteredLeaveValues = leaveValues.where((leave) {
      if (selectedDate == null) {
        return true; // No filter, show all
      }
      DateTime startDate = DateTime.parse(leave['startDate']);
      DateTime endDate = DateTime.parse(leave['endDate']);
      return startDate.isAtSameMomentAs(selectedDate!) ||
          endDate.isAtSameMomentAs(selectedDate!);
    }).toList();

    if (filteredLeaveValues.isEmpty && selectedDate != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 350),
        child: Center(
            child: Text(
          'No leave available for this date',
          style: LeaveFontStyle.style,
        )),
      );
    }

    // Sort leaveValues based on the sorting order
    filteredLeaveValues.sort((a, b) {
      DateTime startDateA = DateTime.parse(a['startDate']);
      DateTime startDateB = DateTime.parse(b['startDate']);
      return isAscending
          ? startDateA.compareTo(startDateB)
          : startDateB.compareTo(startDateA);
    });
    final displayValues =
        showAll ? filteredLeaveValues : filteredLeaveValues.take(200).toList();
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: displayValues.length,
              itemBuilder: (context, index) {
                final leave = displayValues[index];
                final startDate = DateTime.parse(leave['startDate']);
                final endDate = DateTime.parse(leave['endDate']);
                return Column(children: [
                  LeaveEventCard(
                    leaveType: leave['leaveType'],
                    startDate: startDate,
                    endDate: endDate,
                    leaveStatus: leave['leaveStatus'],
                    leaveCause: leave['causes'],
                  ),
                  const SizedBox(
                    height: 6,
                  )
                ]);
              },
            ),
          ),
          // if (filteredLeaveValues.length > 8)
          //   ElevatedButton(
          //     onPressed: () {
          //       setState(() {
          //         showAll = !showAll;
          //       });
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: AppColors.blackShade,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10)),
          //     ),
          //     child: Text(
          //       showAll ? 'Show Less' : 'View All',
          //       style: const TextStyle(
          //         color: AppColors.lightblue,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  // Method to toggle the sorting order
  void _toggleSortOrder() {
    setState(() {
      isAscending = !isAscending;
    });
  }

  // Method to select a date for filtering
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: AppColors.lightblue,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            scaffoldBackgroundColor:
                AppColors.backgroundColor, // Background color of calendar
            dialogBackgroundColor:
                AppColors.backgroundColor, // Dialog background

            colorScheme: const ColorScheme.dark(
              primary: AppColors.lightblue, // Selected date background
              onPrimary: Colors.black, // Color of selected date text
              onSurface: AppColors
                  .lightblue, // Text color for rest of the calendar (month, year, etc.)
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedDateText = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }
}
