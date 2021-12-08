import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AddEditBalanceWidget extends StatefulWidget {
  final TypeBalance typeBalance;
  final DateTime actualMonth;
  final void Function()? onAdded;
  final void Function(BalanceModel oldBalance, BalanceModel? balanceEdited)?
      onEdited;
  final BalanceModel? balanceEdit;

  const AddEditBalanceWidget({
    Key? key,
    this.typeBalance = TypeBalance.inputs,
    required this.actualMonth,
    this.onAdded,
    this.onEdited,
    this.balanceEdit,
  }) : super(key: key);

  @override
  State<AddEditBalanceWidget> createState() => _AddEditBalanceWidgetState();
}

class _AddEditBalanceWidgetState extends State<AddEditBalanceWidget> {
  bool loadingSave = false;
  BalanceModel? balanceEdit;

  late bool editing;
  late bool valueSWitch;
  late TextEditingController _ctlNome;
  late TextEditingController _ctlValor;
  late TextEditingController _ctlParcelas;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    balanceEdit = widget.balanceEdit;
    _ctlNome = TextEditingController(text: balanceEdit?.title);
    _ctlValor = MoneyMaskedTextController(
      initialValue: balanceEdit?.valueTotal ?? 0.0,
      decimalSeparator: ',',
      thousandSeparator: '.',
      leftSymbol: 'R\$ ',
    );
    editing = balanceEdit != null;
    _ctlParcelas = TextEditingController(
      text: editing ? balanceEdit?.numberInstallments.toString() : '1',
    );
    valueSWitch = balanceEdit != null ? balanceEdit!.realized : false;
  }

  _saveInStorge(int parcelas, double valorTotal) {
    late BalanceModel firstBalance;
    for (int i = 1; i <= parcelas; i++) {
      if (i == 1) {
        String uuid = const Uuid().v4();
        firstBalance = BalanceModel(
          title: _ctlNome.text,
          type: widget.typeBalance,
          uuid: uuid,
          value: valorTotal / parcelas,
          valueTotal: valorTotal,
          numberInstallments: parcelas,
          realized: valueSWitch,
          installment: i,
          uuidParent: uuid,
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
  }

  _handleSave() {
    int parcelas = int.parse(_ctlParcelas.text);
    double valorTotal = AppFormats.stringMoneyToDouble(_ctlValor.text);
    _saveInStorge(parcelas, valorTotal);
    widget.onAdded!();
  }

  _editInStorgeInstallment(int parcelas, double valorTotal,
      {int? limiteParcelas, int? sizeLoop}) async {
    int limitInstallment = limiteParcelas ?? parcelas;
    DateTime actualMonth = widget.actualMonth;
    DateTime monthParentBalance = DateTime(
      actualMonth.year,
      actualMonth.month - (balanceEdit!.installment - 1),
      actualMonth.day,
    );

    BalanceModel? parentBalance = await AppStorage.getBalanceByUuid(
        balanceEdit!.uuidParent ?? '',
        balanceEdit!.type ?? TypeBalance.inputs,
        AppStorage.getKeyMonth(monthParentBalance));

    int stopLoop = sizeLoop ?? parcelas;
    BalanceModel? balanceEdited;

    for (int i = 1; i <= stopLoop; i++) {
      if (i == 1) {
        BalanceModel newBalance = BalanceModel(
          title: _ctlNome.text,
          realized: valueSWitch,
          valueTotal: valorTotal,
          value: valorTotal / parcelas,
          type: parentBalance!.type,
          uuid: parentBalance.uuid,
          numberInstallments: parcelas,
          installment: i,
          uuidParent: parentBalance.uuidParent,
        );

        AppStorage.updateBalance(
            newBalance, AppStorage.getKeyMonth(monthParentBalance));
        if (balanceEdit!.uuid == newBalance.uuid) {
          balanceEdited = newBalance;
        }
      } else {
        DateTime monthEdit = DateTime(monthParentBalance.year,
            monthParentBalance.month + (i - 1), monthParentBalance.day);
        BalanceModel? prevBalance = await AppStorage.getBalanceByUuidParent(
            parentBalance?.uuidParent ?? '',
            parentBalance?.type ?? TypeBalance.inputs,
            AppStorage.getKeyMonth(monthEdit));
        late BalanceModel newBalance;

        if (prevBalance != null) {
          newBalance = BalanceModel(
            title: _ctlNome.text,
            type: balanceEdit!.type,
            uuid: prevBalance.uuid,
            value: valorTotal / parcelas,
            valueTotal: valorTotal,
            numberInstallments: parcelas,
            realized: valueSWitch,
            installment: i,
            uuidParent: prevBalance.uuidParent,
          );
          if (i > limitInstallment) {
            AppStorage.deleteBalance(
                prevBalance, AppStorage.getKeyMonth(monthEdit));
          } else {
            AppStorage.updateBalance(
                newBalance, AppStorage.getKeyMonth(monthEdit));
            if (balanceEdit!.uuid == newBalance.uuid) {
              balanceEdited = newBalance;
            }
          }
        } else {
          newBalance = BalanceModel(
            title: _ctlNome.text,
            type: balanceEdit!.type,
            uuid: const Uuid().v4(),
            value: valorTotal / parcelas,
            valueTotal: valorTotal,
            numberInstallments: parcelas,
            realized: valueSWitch,
            installment: i,
            uuidParent: parentBalance!.uuid,
          );
          AppStorage.addBalance(newBalance, AppStorage.getKeyMonth(monthEdit));
        }
        widget.onEdited!(balanceEdit!, balanceEdited);
      }
    }
  }

  _handleEdit() {
    int parcelas = int.parse(_ctlParcelas.text);
    double valorTotal = AppFormats.stringMoneyToDouble(_ctlValor.text);

    // Não alterado o número de parcelas e simples
    if (balanceEdit!.numberInstallments == parcelas && parcelas <= 1) {
      BalanceModel balanceEdited = BalanceModel(
        title: _ctlNome.text,
        realized: valueSWitch,
        valueTotal: valorTotal,
        value: valorTotal,
        type: balanceEdit!.type,
        uuid: balanceEdit!.uuid,
        numberInstallments: balanceEdit!.numberInstallments,
        installment: balanceEdit!.installment,
        uuidParent: balanceEdit!.uuidParent,
      );
      AppStorage.updateBalance(
          balanceEdited, AppStorage.getKeyMonth(widget.actualMonth));
      widget.onEdited!(balanceEdit!, balanceEdited);
      // Não alterado o número de parcelas, parcelado
    } else if (balanceEdit!.numberInstallments == parcelas && parcelas > 1) {
      _editInStorgeInstallment(parcelas, valorTotal);
    } else if (balanceEdit!.numberInstallments != parcelas &&
        parcelas < balanceEdit!.numberInstallments) {
      _editInStorgeInstallment(parcelas, valorTotal,
          limiteParcelas: parcelas, sizeLoop: balanceEdit!.numberInstallments);
    } else if (balanceEdit!.numberInstallments != parcelas &&
        parcelas > balanceEdit!.numberInstallments) {
      _editInStorgeInstallment(
        parcelas,
        valorTotal,
      );
    }

    // late BalanceModel firstBalance;

    // for (int i = 1; i <= parcelas; i++) {
    //   if (i == 1) {
    //     firstBalance = BalanceModel(
    //       title: _ctlNome.text,
    //       type: balanceEdit!.type,
    //       uuid: balanceEdit!.uuid,
    //       value: valorTotal / parcelas,
    //       valueTotal: valorTotal,
    //       numberInstallments: parcelas,
    //       realized: valueSWitch,
    //       installment: i,
    //     );
    //     AppStorage.addBalance(
    //         firstBalance, AppStorage.getKeyMonth(widget.actualMonth));
    //   } else {
    //     BalanceModel newBalance = BalanceModel(
    //       title: _ctlNome.text,
    //       type: widget.typeBalance,
    //       uuid: const Uuid().v4(),
    //       value: valorTotal / parcelas,
    //       valueTotal: valorTotal,
    //       numberInstallments: parcelas,
    //       realized: valueSWitch,
    //       installment: i,
    //       uuidParent: firstBalance.uuid,
    //     );
    //     DateTime actualMonth = widget.actualMonth;
    //     DateTime monthSave = DateTime(
    //         actualMonth.year, actualMonth.month + (i - 1), actualMonth.day);
    //     AppStorage.addBalance(newBalance, AppStorage.getKeyMonth(monthSave));
    //   }
    // }
    // widget.onEdited!();
  }

  _handleSaveBalance() {
    final FormState? form = _formKey.currentState;
    if (!form!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.always);
    } else {
      editing ? _handleEdit() : _handleSave();
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
                autofocus: !editing,
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
