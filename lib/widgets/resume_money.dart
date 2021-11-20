import 'package:flutter/widgets.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/theme/app_text_styles.dart';
import 'package:plans_gastos/utils/formats.dart';

class ResumeMoneyWidget extends StatelessWidget {
  final String label;
  final double value;
  final bool center;

  const ResumeMoneyWidget({
    Key? key,
    required this.label,
    required this.value,
    this.center = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.paragraphSemiBold(color: AppColors.whiteDesable),
        ),
        const SizedBox(height: 5),
        Text(
          AppFormats.valueToMoney(value),
          style:
              center ? AppTextStyles.h2SemiBold() : AppTextStyles.h3SemiBold(),
        )
      ],
    );
  }
}
