import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/theme/app_text_styles.dart';
import 'package:plans_gastos/utils/enuns.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  // final bool label;
  final bool enabled;
  final bool autofocus;
  final String labelText;
  final String hintText;
  final Color fillColor;
  final ValueChanged<dynamic>? onChange;
  final TypeInput type;
  final TypeBalance typeBalance;
  final bool valueSWitch;
  final int initialValue;
  final List<TextInputFormatter>? inputFormatters;

  const InputWidget({
    Key? key,
    this.controller,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.labelText = "",
    this.hintText = "",
    this.fillColor = AppColors.primary,
    this.onChange,
    this.type = TypeInput.text,
    this.typeBalance = TypeBalance.inputs,
    this.valueSWitch = false,
    this.inputFormatters,
    this.initialValue = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        children: [
          Row(
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
              Expanded(flex: 4, child: _buildInput(context))
            ],
          ),
          const Divider(color: AppColors.grayLight, endIndent: 2),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    bool isDanger = typeBalance == TypeBalance.outputs;

    Color inputStateColor = isDanger ? AppColors.secondary : AppColors.primary;
    UnderlineInputBorder disabledBorder = const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
    );

    Size sizeScreen = MediaQuery.of(context).size;
    if (type == TypeInput.text) {
      return TextFormField(
        inputFormatters: inputFormatters,
        autofocus: autofocus,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          fillColor: fillColor,
          hintText: hintText,
          hintStyle: AppTextStyles.h6Regular(
            color: AppColors.black.withOpacity(0.3),
          ),
          enabledBorder: disabledBorder,
          focusedBorder: disabledBorder,
          errorBorder: disabledBorder,
          focusedErrorBorder: disabledBorder,
        ),
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChange,
        enabled: enabled,
        cursorColor: inputStateColor,
        textAlign: TextAlign.right,
        style: AppTextStyles.h6Regular(color: inputStateColor),
      );
    } else if (type == TypeInput.switchh) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Switch(
            value: valueSWitch,
            onChanged: onChange,
            activeTrackColor: isDanger
                ? AppColors.secondary.withOpacity(0.4)
                : AppColors.primary.withOpacity(0.4),
            activeColor: isDanger ? AppColors.secondary : AppColors.primary,
          ),
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: sizeScreen.width <= 350 ? 50 : 90),
        child: CupertinoSpinBox(
          min: 1,
          max: 20,
          value: initialValue.toDouble(),
          onChanged: onChange,
          textStyle: AppTextStyles.h6Regular(color: AppColors.black),
          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          cursorColor: Colors.red,
          incrementIcon: Icon(
            Icons.add,
            color: inputStateColor,
          ),
          decrementIcon: Icon(
            Icons.horizontal_rule_sharp,
            color: inputStateColor,
          ),
        ),
      );
    }
  }
}
