import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/textStyle.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final IconData icon;
  final String label;
  final Function(DateTime) onDateSelected;

  const DatePickerField({
    super.key,
    required this.icon,
    required this.label,
    required this.onDateSelected,
    DateTime? selectedDate,
  });

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: AppColors.lightblue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            scaffoldBackgroundColor:
                AppColors.backgroundColor, // Background color of calendar
            dialogBackgroundColor:
                AppColors.backgroundColor, // Dialog background

            colorScheme: const ColorScheme.dark(
              primary: AppColors.lightblue, // Selected date background
              onPrimary: Colors.black, // Color of selected date text
              onSurface: AppColors
                  .lightblue, // Text color for rest of the calendar (month, year, etc.)
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.lightblue,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.lightblue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.icon,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDate == null
                    ? widget.label
                    : DateFormat('dd/MM/yyyy').format(selectedDate!),
                style: LeaveFontStyle.style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
