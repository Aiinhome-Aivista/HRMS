import 'package:flutter/material.dart';
import 'package:hrms/components/timingDetails.dart';
import 'package:hrms/styleColor.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DateDisplay extends StatefulWidget {
  final DateTime selectedDay;
  final List<dynamic> attendanceData;

  // Constructor to accept the selectedDay
  const DateDisplay(
      {required this.selectedDay, super.key, required this.attendanceData});

  @override
  State<DateDisplay> createState() => _DateDisplayState();
}

class _DateDisplayState extends State<DateDisplay> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  // Sample JSON list of dates to highlight (YYYY-MM-DD format)
  List<dynamic> _highlightedDates = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    fetchAttendance();
    // print('get all attendance data: ${widget.attendanceData}');
  }

  void fetchAttendance() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _highlightedDates = widget.attendanceData;
    });
    print('get all attendance data: $_highlightedDates');
  }

  // Function to get the suffix for the day
  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // Check if the given day should be highlighted
  bool isHighlighted(DateTime day) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(day);
    return _highlightedDates.contains(formattedDate);
  }

  // Check if the given day should be highlighted and return its color
  Color? getHighlightColor(DateTime day) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(day);

    final matchingEntry = _highlightedDates.firstWhere(
      (entry) => entry['date'] == formattedDate,
      orElse: () => {},
    );

    // If no matching date, return null (no color)
    if (matchingEntry.isEmpty) return null;

    String time = matchingEntry['login_time'] ?? '00:00';

    DateTime parsedTime = DateFormat('HH:mm').parse(time);

    DateTime greenStart = DateFormat('HH:mm:ss').parse('06:00:00');
    DateTime greenEnd = DateFormat('HH:mm:ss').parse('10:14:59');
    DateTime yellowStart = DateFormat('HH:mm:ss').parse('10:15:00');
    DateTime yellowEnd = DateFormat('HH:mm:ss').parse('10:29:59');
    DateTime redStart = DateFormat('HH:mm:ss').parse('10:30:00');

    // Determine the color based on the time range
    if ((parsedTime.isAtSameMomentAs(greenStart) ||
            parsedTime.isAfter(greenStart)) &&
        parsedTime.isBefore(greenEnd.add(const Duration(seconds: 1)))) {
      return const Color.fromRGBO(190, 249, 205, 0.5);
    } else if ((parsedTime.isAtSameMomentAs(yellowStart) ||
            parsedTime.isAfter(yellowStart)) &&
        parsedTime.isBefore(yellowEnd.add(const Duration(seconds: 1)))) {
      return const Color.fromRGBO(249, 235, 190, 0.5);
    } else if (parsedTime.isAtSameMomentAs(redStart) ||
        parsedTime.isAfter(redStart)) {
      return const Color.fromRGBO(249, 190, 191, 0.5);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(143, 181, 255, 1),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.selectedDay.day}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(143, 181, 255, 1),
                      ),
                    ),
                    Text(
                      getDaySuffix(widget.selectedDay.day),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(143, 181, 255, 1),
                      ),
                    ),
                  ],
                ),
                Text(
                  DateFormat('MMMM').format(widget.selectedDay),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(143, 181, 255, 1),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${widget.selectedDay.year}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(143, 181, 255, 1),
                  ),
                ),
                Text(
                  DateFormat('EEEE').format(widget.selectedDay),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(143, 181, 255, 1),
                  ),
                )
              ],
            )
          ],
        ),

        // For display calendar
        TableCalendar(
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            // Get the highlight color for the selected day
            Color? highlightColor = getHighlightColor(selectedDay);

            // Find the data for the selected day
            Map<String, dynamic>? selectedDateData =
                _highlightedDates.firstWhere(
              (data) =>
                  data['date'] == DateFormat('yyyy-MM-dd').format(selectedDay),
              orElse: () => null,
            );

            // Extract the required fields or set them to null if not available
            String loginTime = selectedDateData?['login_time'] ?? '';
            String breakStartTime = selectedDateData?['break_start_time'] ?? '';
            String breakCompletionTime =
                selectedDateData?['break_completion_time'] ?? '';
            String logoutTime = selectedDateData?['logout_time'] ?? '';

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return DateModal(
                  selectedDate: selectedDay,
                  highlightColor: highlightColor,
                  loginTime: loginTime,
                  breakStartTime: breakStartTime,
                  breakCompletionTime: breakCompletionTime,
                  logoutTime: logoutTime,
                );
              },
            );
          },
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2101, 12, 31),
          calendarStyle: const CalendarStyle(
            todayTextStyle: TextStyle(
              color: Colors.white,
            ),
            selectedTextStyle: TextStyle(
              color: Colors.white,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AppColors.lightblue,
              shape: BoxShape.circle,
            ),
            defaultTextStyle: TextStyle(color: AppColors.lightblue),
            weekendTextStyle: TextStyle(color: AppColors.lightblue),
            outsideTextStyle: TextStyle(color: AppColors.lightblue),
            outsideDaysVisible: false,
            markerDecoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) =>
                DateFormat.E(locale).format(date)[0],
            weekdayStyle: const TextStyle(
                color: AppColors.lightblue, fontWeight: FontWeight.w700),
            weekendStyle: const TextStyle(
                color: AppColors.lightblue, fontWeight: FontWeight.w700),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
                color: AppColors.lightblue, fontWeight: FontWeight.w500),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: AppColors.lightblue,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: AppColors.lightblue,
            ),
          ),
          rowHeight: 38.0,
          // Custom dayBuilder to highlight specific dates
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              Color? highlightColor = getHighlightColor(day);
              if (highlightColor != null) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: highlightColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              } else {
                return null;
              }
            },
          ),
        )
      ],
    );
  }
}
