import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';

class LeaveEventCard extends StatelessWidget {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String leaveStatus;

  const LeaveEventCard({
    Key? key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.leaveStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageAsset;

    if (leaveStatus == 'Approved') {
      imageAsset = 'assets/images/approve.svg';
    } else if (leaveStatus == 'Cancelled') {
      imageAsset = 'assets/images/cancel.svg';
    } else if (leaveStatus == 'Pending') {
      imageAsset = 'assets/images/pending.svg';
    } else {
      imageAsset = 'assets/images/leaveCardIcon.svg';
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.leaveCardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            decoration: BoxDecoration(
              gradient: title == 'Half Day'
                  ? const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.lightblue,
                        Colors.white,
                      ],
                    )
                  : null,
              color: AppColors.lightblue,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(title, style: leaveCardTextStyle.style),
          ),
          const SizedBox(width: 16.0),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From', style: leaveCardTextStyle.style),
                    Text(
                      '${startDate.day}/${startDate.month}/${startDate.year}',
                      style: leaveCardDateStyle.style,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('To', style: leaveCardTextStyle.style),
                    Text(
                      '${endDate.day}/${endDate.month}/${endDate.year}',
                      style: leaveCardDateStyle.style,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status indicator
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/leaveCardIcon.svg',
                      width: 15,
                      height: 15,
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      imageAsset,
                      width: 15,
                      height: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  leaveStatus,
                  style: leaveCardTextStyle.style,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
