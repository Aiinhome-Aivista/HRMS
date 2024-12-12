import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed; // Function to be called when the button is pressed
  final String buttonText; // Button label text
  final Color backgroundColor; // Background color of the button
  final Color textColor; // Text color of the button
  final EdgeInsets padding; // Padding for button content
  final Duration animationDuration; // Duration for opacity animation

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.backgroundColor = const Color.fromRGBO(143, 181, 255, 1),
    this.textColor = const Color.fromRGBO(8, 12, 17, 1),
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    this.animationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

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
            _isButtonPressed = true; // Button pressed state
          });

          // Call the onPressed callback
          await Future.delayed(widget.animationDuration, () async {
            widget.onPressed();
          });

          setState(() {
            _isButtonPressed = false; // Reset the button state
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
