import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';

class DynamicDonutChart extends StatefulWidget {
  @override
  _DynamicDonutChartState createState() => _DynamicDonutChartState();
}

class _DynamicDonutChartState extends State<DynamicDonutChart> {
  List<dynamic> chartData = [
    {
      "label": "On Time",
      "value": 150,
    },
    {
      "label": "Delay",
      "value": 75,
    },
    {
      "label": "Absolute Delay",
      "value": 10,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double totalValue = chartData.fold(0, (sum, data) => sum + data['value']);
    //double progress = totalValue > 0 ? totalValue / 1000 : 0;

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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        painter: CircularProgressPainter(
                            chartData), // Pass data to painter
                        child: Center(
                          child: Text(
                            '${totalValue.toInt()} days',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: chartData.map<Widget>((data) {
                      return Column(
                        children: [
                          Indicator(
                            color: getColorForLabel(data['label']),
                            text: data['label'],
                            value: data['value'],
                            isSquare: false,
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final List<dynamic> chartData;

  CircularProgressPainter(this.chartData);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 20.0;

    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Paint foregroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = (size.width - strokeWidth) / 2;

    canvas.drawCircle(center, radius, backgroundPaint);

    double totalValue = chartData.fold(0, (sum, data) => sum + data['value']);
    // double startAngle = -pi / 2;

    //new implement
    double totalAngle = 2 * math.pi; // 360 degrees in radians
    double gapAngle = 10 * math.pi / 180; // Convert 10 degrees to radians

    // Calculate the remaining angle available for the segments after considering the gaps
    double totalGap = gapAngle * (chartData.length - 1); // Total gap angle
    double availableAngle =
        totalAngle - totalGap; // Angle available for segments

    double startAngle = -math.pi / 2; // Start from the top of the circle

    for (var data in chartData) {
      // Calculate the sweep angle for each segment based on the available angle
      double sweepAngle = (data['value'] / totalValue) * availableAngle;

      //double sweepAngle = (data['value'] / totalValue) * 2 * pi;
      foregroundPaint.color = getColorForLabel(data['label']);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        foregroundPaint,
      );
      // startAngle += sweepAngle;
      // Update start angle for the next segment, adding the gap after the segment
      startAngle += sweepAngle + gapAngle; // Add gap between segments
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final int value;
  final bool isSquare;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.value,
    required this.isSquare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              text,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            Text(
              '$value days',
              style: const TextStyle(fontSize: 8),
            ),
          ],
        ),
      ],
    );
  }
}

Color getColorForLabel(String label) {
  Map<String, Color> colorMap = {
    "On Time": const Color.fromRGBO(190, 249, 205, 0.5),
    "Delay": const Color.fromRGBO(249, 235, 190, 0.5),
    "Absolute Delay": const Color.fromRGBO(249, 190, 191, 0.5),
  };

  return colorMap[label] ?? Colors.grey; // Fallback color
}
