import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';

class LeaveDaysShow extends StatefulWidget {
  const LeaveDaysShow({super.key});

  @override
  State<LeaveDaysShow> createState() => _LeaveDaysShowState();
}

class _LeaveDaysShowState extends State<LeaveDaysShow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  final int totalLeave = 13;
  final int usedLeave = 05;

  @override
  void initState() {
    super.initState();

    double progress = usedLeave / totalLeave;
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Define the animation from 0.0 to the dynamic progress value
    _progressAnimation = Tween<double>(begin: 0.0, end: progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: 190,
        child: Card(
          color: AppColors.card,
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
                Text(
                  'Casual leave',
                  style: leaveDaysFontStyle.style,
                ),
                const SizedBox(height: 10),
                _buildLeaveInfo('Yearly', totalLeave.toString()),
                const SizedBox(height: 8),
                _buildLeaveInfo('Monthly', '01'),
                const SizedBox(height: 10),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return _buildProgressBar(_progressAnimation.value);
                  },
                ),
              ],
            ),
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
          style: donutChartFontStyle.style,
        ),
        Text(
          value,
          style: donutChartNumStyle.style,
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
              text: TextSpan(
                children: [
                  TextSpan(
                    text: usedLeave.toString(),
                    style: donutChartNumStyle.style,
                  ),
                  TextSpan(
                    text: ' /$totalLeave',
                    style: donutChartFontStyle.style,
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
