import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
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
  late int _ctlParcelas;
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
    _ctlParcelas = editing ? balanceEdit?.numberInstallments ?? 1 : 1;
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
          parentDate: DateTime.now(),
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
          installment: i,
          uuidParent: firstBalance.uuid,
          parentDate: firstBalance.parentDate,
        );
        DateTime actualMonth = widget.actualMonth;
        DateTime monthSave = DateTime(
            actualMonth.year, actualMonth.month + (i - 1), actualMonth.day);
        AppStorage.addBalance(newBalance, AppStorage.getKeyMonth(monthSave));
      }
    }
  }

  _handleSave() {
    int parcelas = _ctlParcelas;
    double valorTotal = AppFormats.stringMoneyToDouble(_ctlValor.text);
    _saveInStorge(parcelas, valorTotal);
    widget.onAdded!();
  }

  _editInStorgeInstallment(int parcelas, double valorTotal,
      {int? limiteParcelas, int? sizeLoop}) async {
    int limitInstallment = limiteParcelas ?? parcelas;
    DateTime monthParentBalance = balanceEdit!.parentDate;
    String monthStr = AppStorage.getKeyMonth(monthParentBalance);

    BalanceModel? parentBalance = await AppStorage.getBalanceByUuid(
        balanceEdit!.uuidParent,
        balanceEdit!.type ?? TypeBalance.inputs,
        monthStr);

    int stopLoop = sizeLoop ?? parcelas;
    BalanceModel? balanceEdited;

    if (parentBalance == null) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro ao editar!'),
        ),
      );
    }

    for (int i = 1; i <= stopLoop; i++) {
      if (i == 1) {
        BalanceModel newBalance = BalanceModel(
          title: _ctlNome.text,
          realized: parentBalance!.uuid == balanceEdit!.uuid
              ? valueSWitch
              : parentBalance.realized,
          valueTotal: valorTotal,
          value: valorTotal / parcelas,
          type: parentBalance.type,
          uuid: parentBalance.uuid,
          numberInstallments: parcelas,
          installment: i,
          uuidParent: parentBalance.uuidParent,
          parentDate: parentBalance.parentDate,
        );

        AppStorage.updateBalance(
            newBalance, AppStorage.getKeyMonth(monthParentBalance));
        if (balanceEdit!.uuid == newBalance.uuid) {
          balanceEdited = newBalance;
        }
      } else {
        DateTime monthEdit = DateTime(monthParentBalance.year,
            monthParentBalance.month + (i - 1), monthParentBalance.day);
        String keyMonth = AppStorage.getKeyMonth(monthEdit);

        BalanceModel? prevBalance = await AppStorage.getBalanceByUuidParent(
            parentBalance!.uuidParent, parentBalance.type!, keyMonth);
        late BalanceModel newBalance;

        if (prevBalance != null) {
          newBalance = BalanceModel(
            title: _ctlNome.text,
            type: balanceEdit!.type,
            uuid: prevBalance.uuid,
            value: valorTotal / parcelas,
            valueTotal: valorTotal,
            numberInstallments: parcelas,
            realized: prevBalance.uuid == balanceEdit!.uuid
                ? valueSWitch
                : prevBalance.realized,
            installment: i,
            uuidParent: prevBalance.uuidParent,
            parentDate: prevBalance.parentDate,
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
            installment: i,
            uuidParent: parentBalance.uuid,
            parentDate: parentBalance.parentDate,
          );
          AppStorage.addBalance(newBalance, AppStorage.getKeyMonth(monthEdit));
        }
      }
    }
    widget.onEdited!(balanceEdit!, balanceEdited);
  }

  _handleEdit() {
    int parcelas = _ctlParcelas;
    double valorTotal = AppFormats.stringMoneyToDouble(_ctlValor.text);

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
        parentDate: balanceEdit!.parentDate,
      );
      AppStorage.updateBalance(
          balanceEdited, AppStorage.getKeyMonth(widget.actualMonth));
      widget.onEdited!(balanceEdit!, balanceEdited);
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
                labelText: 'Parcela(s)',
                initialValue: _ctlParcelas,
                typeBalance: widget.typeBalance,
                keyboardType: TextInputType.number,
                type: TypeInput.spin,
                onChange: (value) {
                  setState(() {
                    _ctlParcelas = value.toInt();
                  });
                },
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
