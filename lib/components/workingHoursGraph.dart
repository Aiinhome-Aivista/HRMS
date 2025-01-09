import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';

class WorkingHoursGraph extends StatefulWidget {
  const WorkingHoursGraph({super.key});

  @override
  State<WorkingHoursGraph> createState() => _WorkingHoursGraphState();
}

class _WorkingHoursGraphState extends State<WorkingHoursGraph> {
  final List<int> workingHours = [06, 10, 06, 06, 10, 09, 06, 08, 07, 10];

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
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  workingHours.length,
                  (index) => Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Bar for working hours
                      Container(
                        width: 20,
                        height: workingHours[index] * 9.0,
                        decoration: const BoxDecoration(
                          color: AppColors.lightblue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        // Circle with hours inside
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
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
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.unselectedNavBarColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.lightblue,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
