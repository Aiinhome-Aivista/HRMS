import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DateDisplay extends StatefulWidget {
  final DateTime selectedDay;

  // Constructor to accept the selectedDay
  const DateDisplay({required this.selectedDay, Key? key}) : super(key: key);

  @override
  State<DateDisplay> createState() => _DateDisplayState();
}

class _DateDisplayState extends State<DateDisplay> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  // Function to get the suffix for the day
  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th'; // Special case for 11th, 12th, and 13th
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
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(143, 181, 255, 1),
                      ),
                    ),
                    Text(
                      getDaySuffix(widget.selectedDay.day),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(143, 181, 255, 1),
                      ),
                    ),
                  ],
                ),
                Text(
                  DateFormat('MMMM').format(
                      widget.selectedDay), // Formats the month as the full name
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(143, 181, 255, 1),
                  ),
                )
              ],
            ),
            Column(
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

        //For display calendar
        TableCalendar(
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          firstDay: DateTime.utc(2020, 1, 1), // Start of calendar range
          lastDay: DateTime.utc(2030, 12, 31), // End of calendar range
          calendarStyle: const CalendarStyle(
            todayTextStyle: TextStyle(
              color: Colors.white, // Color of today's date
            ),
            selectedTextStyle: TextStyle(
              color: Colors.white, // Color of selected day
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blue, // Background color of selected day
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Color.fromRGBO(
                  143, 181, 255, 1), // Background color for today's date
              shape: BoxShape.circle,
            ),
            defaultTextStyle: TextStyle(
                color: Color.fromRGBO(143, 181, 255,
                    1) // Color of all default dates (not selected, not today)
                ),
            weekendTextStyle: TextStyle(
                color: Color.fromRGBO(143, 181, 255,
                    1) // Color of weekend days (Saturday and Sunday)
                ),
            outsideTextStyle: TextStyle(
                color: Color.fromRGBO(143, 181, 255,
                    1) // Color of the days outside the current month
                ),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: Color.fromRGBO(
                  143, 181, 255, 1), // Color of weekdays (Mon-Fri)
            ),
            weekendStyle: TextStyle(
                color: Color.fromRGBO(
                    143, 181, 255, 1) // Color of weekend days (Sat, Sun)
                ),
          ),
        )
      ],
    );
  }
}
