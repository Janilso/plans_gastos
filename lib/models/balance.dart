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
}
