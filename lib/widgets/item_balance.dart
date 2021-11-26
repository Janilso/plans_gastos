import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/theme/app_text_styles.dart';
import 'package:plans_gastos/utils/formats.dart';
import "package:plans_gastos/utils/string_extension.dart";

class ItemBalanceWidget extends StatelessWidget {
  final String name;
  final double value;
  final bool danger;

  const ItemBalanceWidget({
    Key? key,
    required this.name,
    required this.value,
    this.danger = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: danger ? AppColors.secondaryLight : AppColors.primaryLight,
            borderRadius: const BorderRadius.all(Radius.circular(35)),
          ),
          child: Icon(
            Icons.monetization_on_outlined,
            size: 20,
            color: danger ? AppColors.secondary : AppColors.primary,
          )),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(name.capitalize(),
          style: AppTextStyles.h6Regular(color: AppColors.black)),
      trailing: Text(
        AppFormats.valueToMoney(value),
        style: AppTextStyles.h4Regular(
            color: danger ? AppColors.secondary : AppColors.primary),
      ),
    );
  }
}
