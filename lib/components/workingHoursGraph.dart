import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';

class WorkingHoursGraph extends StatefulWidget {
  const WorkingHoursGraph({super.key});

  @override
  State<WorkingHoursGraph> createState() => _WorkingHoursGraphState();
}

class _WorkingHoursGraphState extends State<WorkingHoursGraph>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<int> workingHours = [6, 10, 6, 6, 10, 9, 6, 8, 7, 10];
  final double maxHeight = 100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.unselectedNavBarColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last 10 Day Working Hours',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.lightblue,
                fontFamily: 'Khula',
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: maxHeight,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.lightblue,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      workingHours.length,
                      (index) => AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          double barHeight =
                              (workingHours[index] / 10) * maxHeight;
                          double animatedHeight = _controller.value * barHeight;

                          return Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 20,
                                height: animatedHeight,
                                decoration: const BoxDecoration(
                                  color: AppColors.lightblue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.lightblue,
                                    border: Border.all(
                                      color: AppColors.unselectedNavBarColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${workingHours[index]}',
                                      style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.unselectedNavBarColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
