import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;
  final Duration animationDuration;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.backgroundColor = AppColors.lightblue,
    this.textColor = const Color.fromRGBO(8, 12, 17, 1),
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isButtonPressed ? 0.7 : 1.0,
      duration: widget.animationDuration,
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            _isButtonPressed = true;
          });

          // Call the onPressed callback
          await Future.delayed(widget.animationDuration, () async {
            widget.onPressed();
          });

          setState(() {
            _isButtonPressed = false;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          padding: widget.padding,
        ),
        child: Text(
          widget.buttonText,
          style: TextStyle(
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}
