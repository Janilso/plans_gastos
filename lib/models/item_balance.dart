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
  String title;
  double value;
  TypeBalance? type;
  bool realized;

  BalanceModel({
    required this.uuid,
    required this.title,
    this.type = TypeBalance.inputs,
    this.value = 0,
    this.realized = false,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
        uuid: json["uuid"],
        title: json["title"],
        value: json["value"],
        type: EnumToString.fromString(TypeBalance.values, json["type"]),
        realized: json["realized"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "title": title,
        "value": value,
        "type": EnumToString.convertToString(type),
        "realized": realized,
      };
}
