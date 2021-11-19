import 'dart:convert';

ItemBalance itemBalanceFromJson(String str) =>
    ItemBalance.fromJson(json.decode(str));

String itemBalanceToJson(ItemBalance data) => json.encode(data.toJson());

class ItemBalance {
  String uuid;
  String title;
  double value;

  ItemBalance({
    required this.uuid,
    required this.title,
    this.value = 0,
  });

  factory ItemBalance.fromJson(Map<String, dynamic> json) => ItemBalance(
        uuid: json["uuid"],
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "title": title,
        "value": value,
      };
}
