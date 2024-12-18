import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/components/CustomButton.dart';
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
      "title": "Full Day",
      "startDate": "2024-12-25",
      "endDate": "2024-12-30",
      "leaveStatus": "Approved"
    },
    {
      "title": "Half Day",
      "startDate": "2024-12-31",
      "endDate": "2024-12-31",
      "leaveStatus": "Pending"
    },
    {
      "title": "Full Day",
      "startDate": "2025-01-05",
      "endDate": "2025-01-05",
      "leaveStatus": "Approved"
    },
    {
      "title": "Half Day",
      "startDate": "2025-01-10",
      "endDate": "2025-01-10",
      "leaveStatus": "Cancelled"
    },
    {
      "title": "Full Day",
      "startDate": "2025-02-15",
      "endDate": "2025-02-17",
      "leaveStatus": "Pending"
    },
    {
      "title": "Half Day",
      "startDate": "2025-03-22",
      "endDate": "2025-03-22",
      "leaveStatus": "Approved"
    },
    {
      "title": "Full Day",
      "startDate": "2025-04-01",
      "endDate": "2025-04-03",
      "leaveStatus": "Approved"
    },
    {
      "title": "Half Day",
      "startDate": "2025-05-12",
      "endDate": "2025-05-12",
      "leaveStatus": "Pending"
    },
  ];

  bool isAscending = true;
  DateTime? selectedDate;
  String? selectedDateText;

  @override
  void initState() {
    super.initState();
    _resetFilters(); // Reset filters on page load
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
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/arrow.svg',
              width: 22, height: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Leave', style: HeaderFontStyle.style),
        centerTitle: false,
        titleSpacing: -5,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSortAndFilterRow(),
              const SizedBox(height: 12),
              _buildLeaveList(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildApplyLeaveButton(),
    );
  }

  Widget _buildSortAndFilterRow() {
    return Row(
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
    );
  }

  Widget _buildButton({String? text, IconData? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.lightblue, width: 1),
        ),
        child: Row(
          children: [
            if (icon != null) Icon(icon, size: 22, color: AppColors.lightblue),
            if (text != null)
              Text(text,
                  style: const TextStyle(
                      color: AppColors.lightblue, fontWeight: FontWeight.w600)),
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
      return Center(
          child: Text(
        'No leave available for this date',
        style: LeaveFontStyle.style,
      ));
    }

    // Sort leaveValues based on the sorting order
    filteredLeaveValues.sort((a, b) {
      DateTime startDateA = DateTime.parse(a['startDate']);
      DateTime startDateB = DateTime.parse(b['startDate']);
      return isAscending
          ? startDateA.compareTo(startDateB)
          : startDateB.compareTo(startDateA);
    });

    return Expanded(
      child: ListView.builder(
        itemCount: filteredLeaveValues.length,
        itemBuilder: (context, index) {
          final leave = filteredLeaveValues[index];
          final startDate = DateTime.parse(leave['startDate']);
          final endDate = DateTime.parse(leave['endDate']);
          return Column(children: [
            LeaveEventCard(
              title: leave['title'],
              startDate: startDate,
              endDate: endDate,
              leaveStatus: leave['leaveStatus'],
            ),
            const SizedBox(
              height: 6,
            )
          ]);
        },
      ),
    );
  }

  Widget _buildApplyLeaveButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: SizedBox(
        width: double.infinity,
        child: CustomButton(
          buttonText: 'Apply Leave',
          borderRadius: BorderRadius.circular(12),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Leaveapplyscreen()),
            );
          },
        ),
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
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedDateText = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }
}
