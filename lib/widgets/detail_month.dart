import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:plans_gastos/models/item_balance.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/utils/enuns.dart';
import 'package:plans_gastos/widgets/balance_tab_view.dart';
import 'package:plans_gastos/widgets/resume_money.dart';

class DetailMonthWidget extends StatelessWidget {
  final List<BalanceModel> inputBalances;
  final List<BalanceModel> outputBalances;
  final void Function(TypeBalance typeBalance)? onChangePage;
  final double valorEntradas;
  final double valorSaidas;
  final DateTime? actualMonth;

  const DetailMonthWidget({
    Key? key,
    this.actualMonth,
    this.inputBalances = const [],
    this.outputBalances = const [],
    this.onChangePage,
    this.valorEntradas = 0,
    this.valorSaidas = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ResumeMoneyWidget(label: 'entradas', value: valorEntradas),
                ResumeMoneyWidget(label: 'saídas', value: valorSaidas),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Divider(color: AppColors.whiteDesable, thickness: 2),
          Center(
            child: ResumeMoneyWidget(
              label: 'balanço',
              value: valorEntradas - valorSaidas,
              center: true,
            ),
          ),
          const SizedBox(height: 15),
          BalanceTabViewWidget(
            inputBalances: inputBalances,
            outputBalances: outputBalances,
            onChangePage: onChangePage,
            actualMonth: actualMonth,
          ),
        ],
      ),
    );
  }
}
