import 'package:flutter/material.dart';
import 'package:plans_gastos/theme/app_colors.dart';

ThemeData appTheme = ThemeData(
  fontFamily: "WorkSans",
  primaryColor: AppColors.primary,
  indicatorColor: Colors.white,
  splashColor: Colors.white24,
  splashFactory: InkRipple.splashFactory,
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white,
  errorColor: const Color(0xFFB00020),
  highlightColor: AppColors.primary,
  iconTheme: const IconThemeData(color: AppColors.primary),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
  ),
  tabBarTheme: const TabBarTheme(
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1,
      ),
      unselectedLabelColor: AppColors.whiteDesable,
      unselectedLabelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1,
      )),
  textTheme: _buildTextTheme(base.textTheme),
  primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
);

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    headline6: base.headline6!.copyWith(),
  );
}

final ThemeData base = ThemeData.light();
