import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle h2SemiBold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1,
    );
  }

  static TextStyle h2Bold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1,
    );
  }

  static TextStyle h3Regular({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 1,
    );
  }

  static TextStyle h3SemiBold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1,
    );
  }

  static TextStyle h3Bold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1,
    );
  }

  static TextStyle h3ExtraBold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 24,
      fontWeight: FontWeight.w800,
      height: 1,
    );
  }

  static TextStyle h4Regular({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      height: 1,
    );
  }

  static TextStyle h4SemiBold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1,
    );
  }

  static TextStyle h5Regular({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1,
    );
  }

  static TextStyle h5SemiBold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1,
    );
  }

  static TextStyle h5Bold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1,
    );
  }

  static TextStyle h6Regular({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1,
    );
  }

  static TextStyle h6SemiBold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1,
    );
  }

  static TextStyle h6Bold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1,
    );
  }

  static TextStyle paragraphRegular({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1,
    );
  }

  static TextStyle paragraphSemiBold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1,
    );
  }

  static TextStyle paragraphBold({Color color = Colors.white}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 1,
    );
  }

  static TextStyle customAll(
      {Color color = Colors.white,
      double fontSize = 18,
      FontWeight fontWeight = FontWeight.w400,
      double height = 1.5}) {
    return TextStyle(
      fontFamily: "WorkSans",
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );
  }
}
