import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';

class LeaveDaysShow extends StatefulWidget {
  const LeaveDaysShow({super.key});

  @override
  State<LeaveDaysShow> createState() => _LeaveDaysShowState();
}

class _LeaveDaysShowState extends State<LeaveDaysShow> {
  @override
  Widget build(BuildContext context) {
    double progress = 5 / 13;

    return Container(
      width: double.infinity,
      height: 200,
      child: Card(
        color: AppColors.greyShade,
        margin: const EdgeInsets.all(2),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Casual leave',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildLeaveInfo('Yearly', '13'),
              const SizedBox(height: 8),
              _buildLeaveInfo('Monthly', '01'),
              const SizedBox(height: 10),
              _buildProgressBar(progress),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: '05',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.lightblue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' /13',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.lightblue),
          ),
        ),
      ],
    );
  }
}
