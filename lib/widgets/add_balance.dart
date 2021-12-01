import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:plans_gastos/models/item_balance.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/utils/enuns.dart';
import 'package:plans_gastos/utils/formats.dart';
import 'package:plans_gastos/utils/storage.dart';
import 'package:plans_gastos/utils/validations.dart';
import 'package:plans_gastos/widgets/button_widget.dart';
import 'package:plans_gastos/widgets/input.dart';
import 'package:uuid/uuid.dart';

class AddBalanceWidget extends StatefulWidget {
  final TypeBalance typeBalance;
  final DateTime actualMonth;
  final void Function()? onAdded;

  const AddBalanceWidget({
    Key? key,
    this.typeBalance = TypeBalance.inputs,
    required this.actualMonth,
    this.onAdded,
  }) : super(key: key);

  @override
  State<AddBalanceWidget> createState() => _AddBalanceWidgetState();
}

class _AddBalanceWidgetState extends State<AddBalanceWidget> {
  bool valueSWitch = false;
  bool loadingSave = false;
  final TextEditingController _ctlNome = TextEditingController();
  final TextEditingController _ctlValor = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );

  final TextEditingController _ctlParcelas = TextEditingController(text: '1');
  // final TextEditingController _ctlParcelas = MoneyMaskedTextController(
  //   decimalSeparator: '',
  //   thousandSeparator: '',
  //   leftSymbol: '',
  //   rightSymbol: 'x',
  //   // initialValue: 1,
  //   precision: 0,
  // );

  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _handleSaveBalance() {
    final FormState? form = _formKey.currentState;
    if (!form!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.always);
    } else {
      print('_ctlParcelas ${_ctlParcelas.text}');
      int parcelas = int.parse(_ctlParcelas.text);
      double valorTotal = AppFormats.stringMoneyToDouble(_ctlValor.text);
      late BalanceModel firstBalance;
      for (int i = 1; i <= parcelas; i++) {
        if (i == 1) {
          firstBalance = BalanceModel(
            title: _ctlNome.text,
            type: widget.typeBalance,
            uuid: const Uuid().v4(),
            value: valorTotal / parcelas,
            valueTotal: valorTotal,
            numberInstallments: parcelas,
            realized: valueSWitch,
            installment: i,
          );
          AppStorage.addBalance(
              firstBalance, AppStorage.getKeyMonth(widget.actualMonth));
        } else {
          BalanceModel newBalance = BalanceModel(
            title: _ctlNome.text,
            type: widget.typeBalance,
            uuid: const Uuid().v4(),
            value: valorTotal / parcelas,
            valueTotal: valorTotal,
            numberInstallments: parcelas,
            realized: valueSWitch,
            installment: i,
            uuidParent: firstBalance.uuid,
          );
          DateTime actualMonth = widget.actualMonth;
          DateTime monthSave = DateTime(
              actualMonth.year, actualMonth.month + (i - 1), actualMonth.day);
          AppStorage.addBalance(newBalance, AppStorage.getKeyMonth(monthSave));
        }
      }

      widget.onAdded!();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidate,
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
                controller: _ctlNome,
                labelText: 'Nome',
                hintText: widget.typeBalance == TypeBalance.inputs
                    ? 'Nome do ganho'
                    : 'Nome do gasto',
                autofocus: true,
                validator: AppValidations.defaultValidate,
                typeBalance: widget.typeBalance,
              ),
              const SizedBox(height: 8),
              InputWidget(
                controller: _ctlValor,
                // inputFormatters: [_ctlValor],
                labelText: 'Valor',
                typeBalance: widget.typeBalance,
                validator: AppValidations.money,
                keyboardType: TextInputType.number,
              ),
              InputWidget(
                labelText: 'Realizado',
                onChange: (value) {
                  setState(() {
                    valueSWitch = value;
                  });
                },
                valueSWitch: valueSWitch,
                type: TypeInput.switchh,
                typeBalance: widget.typeBalance,
              ),
              const SizedBox(height: 8),
              InputWidget(
                controller: _ctlParcelas,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9]+")),
                ],
                labelText: 'Parcela(s)',
                valueSWitch: valueSWitch,
                // type: TypeInput.,
                typeBalance: widget.typeBalance,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              ButtonWidget(
                text: 'Salvar',
                icon: Icons.send,
                loading: loadingSave,
                color: widget.typeBalance == TypeBalance.inputs
                    ? AppColors.primary
                    : AppColors.secondary,
                onPressed: _handleSaveBalance,
                // width: ,
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
