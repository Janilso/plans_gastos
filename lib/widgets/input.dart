import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/theme/app_text_styles.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  // final bool label;
  final bool enabled;
  final String labelText;
  final String hintText;
  final Color fillColor;
  final ValueChanged<String>? onChange;
  final bool isDanger;

  const InputWidget({
    Key? key,
    this.controller,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.labelText = "",
    this.hintText = "",
    this.fillColor = AppColors.primary,
    this.onChange,
    this.isDanger = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color inputStateColor = isDanger ? AppColors.secondary : AppColors.primary;
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.grayLight, width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(labelText,
                    style: AppTextStyles.h6Regular(color: AppColors.black)),
              ),
            ),
            Expanded(
              flex: 4,
              child: TextFormField(
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    // filled: true,
                    fillColor: fillColor,
                    hintText: hintText,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    )),
                // style: enabled ? textStyle : textStyleDisabled,
                controller: controller,
                keyboardType: keyboardType,
                validator: validator,
                onChanged: onChange,
                enabled: enabled,
                cursorColor: inputStateColor,
                textAlign: TextAlign.right,
                style: AppTextStyles.h6Regular(color: inputStateColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
