import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/utils/enuns.dart';
import 'package:plans_gastos/widgets/button_widget.dart';
import 'package:plans_gastos/widgets/input.dart';

class AddBalanceWidget extends StatefulWidget {
  final TypeBalance typeBalance;

  const AddBalanceWidget({
    Key? key,
    this.typeBalance = TypeBalance.inputs,
  }) : super(key: key);

  @override
  State<AddBalanceWidget> createState() => _AddBalanceWidgetState();
}

class _AddBalanceWidgetState extends State<AddBalanceWidget> {
  bool valueSWitch = false;
  final TextEditingController _ctlNome = TextEditingController();
  final TextEditingController _ctlValor = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$ ');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
              controller: _ctlNome,
              labelText: 'Nome',
              hintText: widget.typeBalance == TypeBalance.inputs
                  ? 'Nome da entrada'
                  : 'Nome da saída',
              autofocus: true,
              onChange: (value) {
                print('value $value');
              },
              typeBalance: widget.typeBalance,
            ),
            const SizedBox(height: 8),
            InputWidget(
              controller: _ctlValor,
              labelText: 'Valor',
              // hintText: 'R\$ 0,00',
              onChange: (value) {
                print('value $value');
              },
              typeBalance: widget.typeBalance,
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
              icon: FeatherIcons.send,
              loading: true,
              color: widget.typeBalance == TypeBalance.inputs
                  ? AppColors.primary
                  : AppColors.secondary,
              // width: ,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
