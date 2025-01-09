import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/styleColor.dart';
import 'package:intl/intl.dart';

class DateModal extends StatefulWidget {
  final DateTime selectedDate;
  final Color? highlightColor;
  final String loginTime;
  final String breakStartTime;
  final String breakCompletionTime;
  final String logoutTime;

  const DateModal({
    super.key,
    required this.selectedDate,
    this.highlightColor,
    required this.loginTime,
    required this.breakStartTime,
    required this.breakCompletionTime,
    required this.logoutTime,
  });

  @override
  State<DateModal> createState() => _DateModalState();
}

class _DateModalState extends State<DateModal> {
  late String imageAsset;
  late String statusText;

  @override
  void initState() {
    super.initState();
    _determineStatus();
  }

  void _determineStatus() {
    if (widget.highlightColor == const Color.fromRGBO(190, 249, 205, 0.5)) {
      imageAsset = 'assets/images/onTime.svg';
      statusText = 'On Time';
    } else if (widget.highlightColor ==
        const Color.fromRGBO(249, 235, 190, 0.5)) {
      imageAsset = 'assets/images/delay.svg';
      statusText = 'Delay';
    } else if (widget.highlightColor ==
        const Color.fromRGBO(249, 190, 191, 0.5)) {
      imageAsset = 'assets/images/absoluteDelay.svg';
      statusText = 'Absolute Delay';
    } else {
      imageAsset = '';
      statusText = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.lightblue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    imageAsset,
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat('d MMMM, yyyy').format(widget.selectedDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconWithLabelAndTime(
                  'assets/images/home_work.svg', 'Home', widget.loginTime),
              _buildIconWithLabelAndTime('assets/images/breakStart.svg',
                  'Break Start', widget.breakStartTime),
              _buildIconWithLabelAndTime('assets/images/breakEnd.svg',
                  'Break End', widget.breakCompletionTime),
              _buildIconWithLabelAndTime(
                  'assets/images/punchOut.svg', 'Punch Out', widget.logoutTime),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildIconWithLabelAndTime(
      String iconPath, String label, String time) {
    bool isTimeEmpty = time.isEmpty;
    return Column(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          color: isTimeEmpty ? Colors.white : null,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: isTimeEmpty ? Colors.white : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isTimeEmpty ? '--' : time,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: isTimeEmpty ? Colors.white : null,
          ),
        ),
      ],
    );
  }
}
