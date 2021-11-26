import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
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
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$ ');

  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _handleSaveBalance() {
    final FormState? form = _formKey.currentState;
    if (!form!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.always);
    } else {
      BalanceModel newBalance = BalanceModel(
        title: _ctlNome.text,
        type: widget.typeBalance,
        uuid: const Uuid().v4(),
        value: AppFormats.stringMoneyToDouble(_ctlValor.text),
        realized: valueSWitch,
      );
      // AppStorage.clear();
      AppStorage.addBalance(
          newBalance, AppStorage.getKeyMonth(widget.actualMonth));
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
                    ? 'Nome da entrada'
                    : 'Nome da saída',
                autofocus: true,
                validator: AppValidations.defaultValidate,
                typeBalance: widget.typeBalance,
              ),
              const SizedBox(height: 8),
              InputWidget(
                controller: _ctlValor,
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
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
