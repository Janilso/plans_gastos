import 'package:flutter/material.dart';
import 'package:plans_gastos/theme/app_colors.dart';

ThemeData appTheme = ThemeData(
  fontFamily: "WorkSans",
  primaryColor: AppColors.primary,
  indicatorColor: Colors.white,
  splashColor: Colors.white24,
  splashFactory: InkRipple.splashFactory,
  // colorScheme: ColorScheme.fromSwatch().copyWith(
  //   secondary: AppColors.primary, // Your accent color
  // ),
  // accentColor: Colors.white,
  // accentColor: Colors.red,
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white,
  errorColor: const Color(0xFFB00020),
  highlightColor: AppColors.primary,
  iconTheme: const IconThemeData(color: AppColors.primary),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: _buildTextTheme(base.textTheme),
  primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
  // accentTextTheme: _buildTextTheme(base.accentTextTheme),
);

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    headline6: base.headline6!.copyWith(),
  );
}

final ThemeData base = ThemeData.light();
