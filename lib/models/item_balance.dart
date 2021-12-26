import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:plans_gastos/utils/enuns.dart';
import 'package:plans_gastos/utils/formats.dart';

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
  String uuidParent;
  String title;
  double value;
  double valueTotal;
  TypeBalance? type;
  bool realized;
  int installment;
  int numberInstallments;
  DateTime parentDate;

  BalanceModel({
    required this.uuid,
    required this.title,
    required this.valueTotal,
    required this.value,
    required this.installment,
    this.numberInstallments = 1,
    this.type = TypeBalance.inputs,
    this.realized = false,
    required this.uuidParent,
    required this.parentDate,
  });

  @override
  toString() {
    return "uuid: $uuid"
            "\n uuidParent: $uuidParent"
            "\n title: $title"
            "\n value: $value"
            "\n valueTotal: $valueTotal"
            "\n type: $type"
            "\n realized: $realized"
            "\n installment: $installment"
            "\n numberInstallments: $numberInstallments"
            "\n parentDate: " +
        AppFormats.dateToFormat(parentDate);
  }

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
        parentDate: DateTime.parse(json["parentDate"]),
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
        "parentDate": parentDate.toIso8601String(),
      };
}
