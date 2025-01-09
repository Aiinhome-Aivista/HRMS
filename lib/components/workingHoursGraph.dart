import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart'; // Assuming this file defines AppColors

class WorkingHoursGraph extends StatefulWidget {
  const WorkingHoursGraph({super.key});

  @override
  State<WorkingHoursGraph> createState() => _WorkingHoursGraphState();
}

class _WorkingHoursGraphState extends State<WorkingHoursGraph> {
  final List<int> workingHours = [6, 10, 6, 6, 10, 9, 6, 8, 7, 10];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.greyShade,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Last 10 Day Working Hours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                workingHours.length,
                (index) => Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 25, // Adjust width as desired
                      height: workingHours[index] *
                          10.0, // Adjust height based on hours
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Positioned(
                      top: (workingHours[index] * 5.0) / 2 - 5,
                      //left: 2,
                      child: Container(
                        width: 20, // Adjust circle size
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // Background color for circle
                        ),
                        child: Center(
                          child: Text(
                            '${workingHours[index]}',
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ), // Display hours
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
