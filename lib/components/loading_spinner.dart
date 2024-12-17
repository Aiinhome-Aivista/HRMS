import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: AppColors.lightblue,
      ),
    );
  }
}
