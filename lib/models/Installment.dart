const String tableInstallment = 'installment';

class InstallmentFields {
  static const String id = '_id';
  static const String idBalance = 'idBalance';
  static const String value = 'value';
  static const String number = 'number';
  static const String realized = 'realized';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
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
}
