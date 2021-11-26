import 'package:flutter/material.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/theme/app_text_styles.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final GestureTapCallback? onPressed;
  final IconData? icon;
  final double width;
  final Color color;
  final Color fontColor;
  // final bool disabled;
  final bool loading;

  const ButtonWidget({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width = 200,
    this.color = AppColors.primary,
    this.fontColor = Colors.white,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width < 150 ? 150 : width,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(loading ? 0.5 : 1),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox.expand(
        child: TextButton(
          onPressed: loading ? null : onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    text,
                    style: AppTextStyles.h4Regular(color: fontColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (icon == null)
                Container()
              else if (!loading)
                Icon(icon, color: fontColor)
              else if (loading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary.withOpacity(0.5)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
