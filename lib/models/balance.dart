const String tableBalances = 'balances';

class BalanceFields {
  static const String id = "_id";
  static const String title = "title";
  static const String value = "value";
  static const String numbersInstallment = "numbersInstallment";
  static const String type = "type";
  static const String date = "date";
  static const String createdAt = "createdAt";
  static const String updatedAt = "updatedAt";

  static const List<String> values = [
    id,
    title,
    value,
    numbersInstallment,
    type,
    date,
    createdAt,
    updatedAt,
  ];
}

class BalanceModel {
  final int? id;
  final String title;
  final double value;
  final int numbersInstallment;
  final String type;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  BalanceModel({
    this.id,
    required this.title,
    required this.value,
    required this.numbersInstallment,
    required this.type,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, Object?> toJson() => {
        BalanceFields.id: id,
        BalanceFields.title: title,
        BalanceFields.value: value,
        BalanceFields.numbersInstallment: numbersInstallment,
        BalanceFields.date: date.toIso8601String(),
        BalanceFields.createdAt: createdAt.toIso8601String(),
        BalanceFields.updatedAt: updatedAt.toIso8601String(),
      };

  static BalanceModel fromJson(Map<String, Object?> json) => BalanceModel(
        id: json[BalanceFields.id] as int?,
        title: json[BalanceFields.title] as String,
        value: json[BalanceFields.value] as double,
        numbersInstallment: json[BalanceFields.numbersInstallment] as int,
        type: json[BalanceFields.type] as String,
        date: DateTime.parse(json[BalanceFields.date] as String),
        createdAt: DateTime.parse(json[BalanceFields.createdAt] as String),
        updatedAt: DateTime.parse(json[BalanceFields.updatedAt] as String),
      );

  BalanceModel copy({
    int? id,
    String? title,
    double? value,
    int? numbersInstallment,
    String? type,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      BalanceModel(
        id: id ?? this.id,
        title: title ?? this.title,
        value: value ?? this.value,
        numbersInstallment: numbersInstallment ?? this.numbersInstallment,
        type: type ?? this.type,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
