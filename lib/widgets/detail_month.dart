import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:plans_gastos/models/item_balance.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/utils/enuns.dart';
import 'package:plans_gastos/widgets/balance_tab_view.dart';
import 'package:plans_gastos/widgets/resume_money.dart';
import 'package:collection/collection.dart';

class DetailMonthWidget extends StatefulWidget {
  final List<BalanceModel> inputBalances;
  final List<BalanceModel> outputBalances;
  final void Function(TypeBalance typeBalance)? onChangePage;

  final DateTime? actualMonth;

  const DetailMonthWidget({
    Key? key,
    this.actualMonth,
    this.inputBalances = const [],
    this.outputBalances = const [],
    this.onChangePage,
  }) : super(key: key);

  @override
  State<DetailMonthWidget> createState() => _DetailMonthWidgetState();
}

class _DetailMonthWidgetState extends State<DetailMonthWidget> {
  double valorEntradas = 0;
  double valorSaidas = 0;
  List<BalanceModel> stateInputBalances = [];
  List<BalanceModel> stateOutputBalances = [];

  @override
  void didUpdateWidget(covariant DetailMonthWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool changeListInput = const ListEquality()
        .equals(oldWidget.inputBalances, stateInputBalances);
    bool changeListOutput = const ListEquality()
        .equals(oldWidget.outputBalances, stateOutputBalances);

    if (changeListInput || changeListOutput) {
      List valuesBalance =
          _calValuesBalance(widget.inputBalances, widget.outputBalances);
      setState(() {
        valorEntradas = valuesBalance[0];
        valorSaidas = valuesBalance[1];
        stateInputBalances = widget.inputBalances;
        stateOutputBalances = widget.outputBalances;
      });
    }
  }

  List _calValuesBalance(List<BalanceModel> listInputBalances,
      List<BalanceModel> listOutputBalances) {
    double entradas =
        listInputBalances.fold(0, (acum, balance) => acum + balance.value);
    double saidas =
        listOutputBalances.fold(0, (acum, balance) => acum + balance.value);
    return [entradas, saidas];
  }

  _handleRemovebalace(BalanceModel balanceRemoved) {
    if (balanceRemoved.type == TypeBalance.inputs) {
      stateInputBalances
          .removeWhere((BalanceModel item) => balanceRemoved.uuid == item.uuid);
      List<BalanceModel> newListInputBalances = stateInputBalances;

      List valuesBalance =
          _calValuesBalance(newListInputBalances, stateOutputBalances);

      setState(() {
        stateInputBalances = newListInputBalances;
        valorEntradas = valuesBalance[0];
        valorSaidas = valuesBalance[1];
      });
    } else {
      stateOutputBalances
          .removeWhere((BalanceModel item) => balanceRemoved.uuid == item.uuid);
      List<BalanceModel> newlistOutputBalances = stateOutputBalances;

      List valuesBalance =
          _calValuesBalance(stateInputBalances, newlistOutputBalances);
      setState(() {
        stateOutputBalances = newlistOutputBalances;
        valorEntradas = valuesBalance[0];
        valorSaidas = valuesBalance[1];
      });

      // _calValuesBalance(stateInputBalances, newlistOutputBalances);
    }
  }

  _handleEditbalace(BalanceModel oldBalance, BalanceModel? balanceEdited) {
    if (oldBalance.type == TypeBalance.inputs) {
      int indexPrevBalance = stateInputBalances
          .indexWhere((BalanceModel item) => oldBalance.uuid == item.uuid);
      if (balanceEdited != null) {
        stateInputBalances[indexPrevBalance] = balanceEdited;
      } else {
        stateInputBalances.removeAt(indexPrevBalance);
      }
      List<BalanceModel> newListInputBalances = stateInputBalances;
      List valuesBalance =
          _calValuesBalance(newListInputBalances, stateOutputBalances);
      setState(() {
        stateInputBalances = newListInputBalances;
        valorEntradas = valuesBalance[0];
        valorSaidas = valuesBalance[1];
      });
    } else {
      int indexPrevBalance = stateOutputBalances
          .indexWhere((BalanceModel item) => oldBalance.uuid == item.uuid);
      if (balanceEdited != null) {
        stateOutputBalances[indexPrevBalance] = balanceEdited;
      } else {
        stateOutputBalances.removeAt(indexPrevBalance);
      }
      List<BalanceModel> newlistOutputBalances = stateOutputBalances;

      List valuesBalance =
          _calValuesBalance(stateInputBalances, newlistOutputBalances);
      setState(() {
        stateOutputBalances = newlistOutputBalances;
        valorEntradas = valuesBalance[0];
        valorSaidas = valuesBalance[1];
      });
    }
  }

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
                ResumeMoneyWidget(label: 'GANHOS', value: valorEntradas),
                ResumeMoneyWidget(label: 'GASTOS', value: valorSaidas),
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
            inputBalances: widget.inputBalances,
            outputBalances: widget.outputBalances,
            onChangePage: widget.onChangePage,
            actualMonth: widget.actualMonth,
            onRemoveItem: _handleRemovebalace,
            onEditItem: _handleEditbalace,
          )
        ],
      ),
    );
  }
}
