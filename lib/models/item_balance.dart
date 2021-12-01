import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:plans_gastos/utils/enuns.dart';

List<BalanceModel> listBalancesModelFromJson(String str) =>
    List<BalanceModel>.from(
        json.decode(str).map((x) => balanceModelFromJson(x)));

// String listBalancesModelFromJson(List<BalanceModel> list) =>
//     list.from(json.decode(str).map((x) => balanceModelFromJson(x)));

BalanceModel balanceModelFromJson(String str) =>
    BalanceModel.fromJson(json.decode(str));

String balanceModelToJson(BalanceModel data) => json.encode(data.toJson());

class BalanceModel {
  String uuid;
  String? uuidParent;
  String title;
  double value;
  double valueTotal;
  TypeBalance? type;
  bool realized;
  int installment;
  int numberInstallments;

  BalanceModel({
    required this.uuid,
    required this.title,
    required this.valueTotal,
    required this.value,
    required this.installment,
    this.numberInstallments = 1,
    this.type = TypeBalance.inputs,
    this.realized = false,
    this.uuidParent,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
        uuid: json["uuid"],
        title: json["title"],
        valueTotal: json["valueTotal"],
        value: json["value"],
        installment: json["installment"],
        numberInstallments: json["numberInstallments"],
        type: EnumToString.fromString(TypeBalance.values, json["type"]),
        realized: json["realized"],
        uuidParent: json["uuidParent"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "title": title,
        "valueTotal": valueTotal,
        "value": value,
        "installment": installment,
        "numberInstallments": numberInstallments,
        "type": EnumToString.convertToString(type),
        "realized": realized,
        "uuidParent": uuidParent,
      };
}
