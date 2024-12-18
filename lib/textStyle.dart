// ignore_for_file: camel_case_types, file_names
import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';

class HeaderFontStyle {
  static TextStyle get style {
    return const TextStyle(
      fontSize: 24.0,
      fontFamily: 'Khula',
      fontWeight: FontWeight.w700,
      color: AppColors.lightblue,
    );
  }
}

class LeaveFontStyle {
  static TextStyle get style {
    return const TextStyle(
      fontSize: 16.0,
      fontFamily: 'Khula',
      fontWeight: FontWeight.w700,
      color: AppColors.lightblue,
    );
  }
}

class docArchiveFontStyle {
  static TextStyle get style {
    return const TextStyle(
      fontSize: 10.0,
      fontFamily: 'Khula',
      fontWeight: FontWeight.w700,
      color: AppColors.lightblue,
    );
  }
}

class docArchiveNumStyle {
  static TextStyle get style {
    return const TextStyle(
      fontSize: 20.0,
      fontFamily: 'Khula',
      fontWeight: FontWeight.w700,
      color: AppColors.lightblue,
    );
  }
}

class unselectedNavBarTextStyle {
  static TextStyle get style {
    return const TextStyle(
      fontSize: 14.0,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      color: AppColors.unselectedNavBarColor,
    );
  }
}

class selectedNavBarTextStyle {
  static TextStyle get style {
    return const TextStyle(
      fontSize: 14.0,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      color: AppColors.selectedNavBarColor,
    );
  }
}

class leaveCardTextStyle {
  static TextStyle get style {
    return const TextStyle(
      fontSize: 12.0,
      fontFamily: 'Khula',
      fontWeight: FontWeight.w700,
      color: AppColors.unselectedNavBarColor,
    );
  }
}

class leaveCardDateStyle {
  static TextStyle get style {
    return const TextStyle(
      fontSize: 14.0,
      fontFamily: 'Khula',
      fontWeight: FontWeight.w700,
      color: AppColors.unselectedNavBarColor,
    );
  }
}
