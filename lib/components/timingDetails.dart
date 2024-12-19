import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/styleColor.dart';
import 'package:intl/intl.dart';

class DateModal extends StatelessWidget {
  final DateTime selectedDate;
  final Color? highlightColor;

  const DateModal({
    required this.selectedDate,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    String imageAsset = '';
    String statusText = '';
    if (highlightColor == const Color.fromRGBO(190, 249, 205, 0.5)) {
      imageAsset = 'assets/images/onTime.svg';
      statusText = 'On Time';
    } else if (highlightColor == const Color.fromRGBO(249, 235, 190, 0.5)) {
      imageAsset = 'assets/images/delay.svg';
      statusText = 'Delay';
    } else if (highlightColor == const Color.fromRGBO(249, 190, 191, 0.5)) {
      imageAsset = 'assets/images/absoluteDelay.svg';
      statusText = 'Absolute Delay';
    }
    return Container(
      width: double.infinity,
      height: 195,
      decoration: const BoxDecoration(
        color: AppColors.lightblue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.all(16),
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
                    width: 24,
                    height: 24,
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
                DateFormat('d MMMM, yyyy').format(selectedDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconWithLabelAndTime(
                  'assets/images/home_work.svg', 'Home', '2:40'),
              _buildIconWithLabelAndTime(
                  'assets/images/breakStart.svg', 'Break Start', ''),
              _buildIconWithLabelAndTime(
                  'assets/images/breakEnd.svg', 'Break End', ''),
              _buildIconWithLabelAndTime(
                  'assets/images/punchOut.svg', 'Punch Out', '2:40'),
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
