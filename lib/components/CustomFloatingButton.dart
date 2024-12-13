import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final double size;

  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = AppColors.blackShade, // Default color
    this.size = 56.0, // Default size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      elevation: 6.0,
      shape: CircleBorder(),
      child: Icon(icon, color: AppColors.lightblue, size: size * 0.6),
    );
  }
}
