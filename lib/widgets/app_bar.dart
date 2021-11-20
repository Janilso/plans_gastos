import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/theme/app_text_styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isDanger;

  @override
  final Size preferredSize;

  const AppBarWidget({
    Key? key,
    required this.title,
    this.preferredSize = const Size.fromHeight(48.0),
    this.isDanger = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = isDanger ? AppColors.secondary : AppColors.primary;
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        color: color,
        child: AppBar(
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.4),
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              title,
              style: AppTextStyles.h6Regular(color: color),
            ),
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          excludeHeaderSemantics: true,
        ),
      ),
    );
  }
}
