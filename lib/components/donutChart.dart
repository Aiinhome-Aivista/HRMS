import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';

class DynamicDonutChart extends StatefulWidget {
  const DynamicDonutChart({super.key});
  @override
  State<DynamicDonutChart> createState() => _DynamicDonutChartState();
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

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    double totalValue = chartData.fold(0, (sum, data) => sum + data['value']);
    return Container(
      width: double.infinity,
      height: 190,
      child: Card(
        color: AppColors.unselectedNavBarColor,
        margin: const EdgeInsets.all(2),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 5,
                          centerSpaceRadius: 28,
                          sections: chartData.asMap().entries.map((entry) {
                            int index = entry.key;
                            var data = entry.value;
                            bool isTouched = index == touchedIndex;
                            return PieChartSectionData(
                              color: getColorForLabel(data['label']),
                              value: data['value'].toDouble(),
                              title: '',
                              radius: isTouched ? 35 : 20,
                              showTitle: false,
                            );
                          }).toList(),
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1; // Reset when touch ends
                                } else {
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      if (touchedIndex != -1)
                        Positioned(
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            color: Colors.black.withOpacity(0.7),
                            child: Text(
                              chartData[touchedIndex]['label'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '${totalValue.toInt()}',
                                  style: donutChartNumStyle.style),
                              TextSpan(
                                  text: 'Days',
                                  style: donutChartFontStyle.style),
                            ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class _DynamicDonutChartState extends State<DynamicDonutChart> {
//   List<dynamic> chartData = [
//     {
//       "label": "On Time",
//       "value": 150,
//     },
//     {
//       "label": "Delay",
//       "value": 75,
//     },
//     {
//       "label": "Absolute Delay",
//       "value": 10,
//     },
//   ];

//   int touchedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     double totalValue = chartData.fold(0, (sum, data) => sum + data['value']);
//     return Container(
//       width: double.infinity,
//       height: 190,
//       child: Card(
//         color: AppColors.unselectedNavBarColor,
//         margin: const EdgeInsets.all(2),
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Expanded(
//                 flex: 2,
//                 child: AspectRatio(
//                   aspectRatio: 1,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       PieChart(
//                         PieChartData(
//                           borderData: FlBorderData(show: false),
//                           sectionsSpace: 5,
//                           centerSpaceRadius: 28,
//                           sections: chartData.asMap().entries.map((entry) {
//                             int index = entry.key;
//                             var data = entry.value;
//                             bool isTouched = index == touchedIndex;
//                             return PieChartSectionData(
//                               color: getColorForLabel(data['label']),
//                               value: data['value'].toDouble(),
//                               title: '',
//                               radius: isTouched ? 35 : 20,
//                               showTitle: false,
//                             );
//                           }).toList(),
//                           pieTouchData: PieTouchData(
//                             touchCallback:
//                                 (FlTouchEvent event, pieTouchResponse) {
//                               setState(() {
//                                 if (!event.isInterestedForInteractions ||
//                                     pieTouchResponse == null ||
//                                     pieTouchResponse.touchedSection == null) {
//                                   touchedIndex = -1; // Reset when touch ends
//                                 } else {
//                                   touchedIndex = pieTouchResponse
//                                       .touchedSection!.touchedSectionIndex;
//                                 }
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       Center(
//                         child: RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                   text: '${totalValue.toInt()}',
//                                   style: donutChartNumStyle.style),
//                               TextSpan(
//                                   text: 'Days',
//                                   style: donutChartFontStyle.style),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 flex: 2,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: chartData.map<Widget>((data) {
//                       return Column(
//                         children: [
//                           Indicator(
//                             color: getColorForLabel(data['label']),
//                             text: data['label'],
//                             value: data['value'],
//                             isSquare: false,
//                           ),
//                           const SizedBox(height: 8),
//                         ],
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final int value;
  final bool isSquare;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.value,
    required this.isSquare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: color,
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              text,
              style: donutChartFontStyle.style,
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: '$value ', style: donutChartNumStyle.style),
                  TextSpan(text: 'Days', style: donutChartFontStyle.style),
                ],
              ),
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

  return colorMap[label] ?? Colors.grey;
}
