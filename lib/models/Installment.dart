const String tableInstallment = 'installment';

class InstallmentFields {
  static const String id = '_id';
  static const String idBalance = 'idBalance';
  static const String value = 'value';
  static const String number = 'number';
  static const String realized = 'realized';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';

  static const List<String> values = [
    id,
    idBalance,
    value,
    number,
    realized,
    createdAt,
    updatedAt,
  ];
}

class InstallmentModel {
  final int? id;
  final int idBalance;
  final double value;
  final int number;
  final bool realized;
  final DateTime createdAt;
  final DateTime updatedAt;

  InstallmentModel({
    this.id,
    required this.idBalance,
    required this.value,
    required this.number,
    required this.realized,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, Object?> toJson() => {
        InstallmentFields.id: id,
        InstallmentFields.idBalance: idBalance,
        InstallmentFields.value: value,
        InstallmentFields.number: number,
        InstallmentFields.realized: realized ? 1 : 0,
        InstallmentFields.createdAt: createdAt.toIso8601String(),
        InstallmentFields.updatedAt: updatedAt.toIso8601String(),
      };

  static InstallmentModel fromJson(Map<String, Object?> json) =>
      InstallmentModel(
        id: json[InstallmentFields.id] as int?,
        idBalance: json[InstallmentFields.idBalance] as int,
        value: json[InstallmentFields.value] as double,
        number: json[InstallmentFields.number] as int,
        realized: json[InstallmentFields.realized] as int == 1,
        createdAt: DateTime.parse(json[InstallmentFields.createdAt] as String),
        updatedAt: DateTime.parse(json[InstallmentFields.updatedAt] as String),
      );

  InstallmentModel copy({
    int? id,
    int? idBalance,
    double? value,
    int? number,
    bool? realized,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      InstallmentModel(
        id: id ?? this.id,
        idBalance: idBalance ?? this.idBalance,
        value: value ?? this.value,
        number: number ?? this.number,
        realized: realized ?? this.realized,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
