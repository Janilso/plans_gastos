import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/widgets/input.dart';

class AddBalanceWidget extends StatelessWidget {
  const AddBalanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 135,
              height: 5,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: AppColors.grayLight),
            ),
          ),
          const SizedBox(height: 12),
          InputWidget(
            labelText: 'Nome',
            onChange: (String value) {
              print('value $value');
            },
          ),
          const SizedBox(height: 8),
          InputWidget(
            labelText: 'Valor',
            onChange: (String value) {
              print('value $value');
            },
          ),
          InputWidget(
            labelText: 'Realizado',
            onChange: (String value) {
              print('value $value');
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
