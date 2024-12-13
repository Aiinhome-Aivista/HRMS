import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';
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
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) =>
                DateFormat.E(locale).format(date)[0],
            weekdayStyle: const TextStyle(color: AppColors.lightblue),
            weekendStyle: const TextStyle(color: AppColors.lightblue),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          rowHeight: 38.0,
        )
      ],
    );
  }
}
