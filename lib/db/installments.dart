import 'package:plans_gastos/models/Installment.dart';
import 'package:plans_gastos/utils/database_helper.dart';

class InstallmentsDatabase {
  Future<InstallmentModel> create(InstallmentModel installment) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert(tableInstallment, installment.toJson());
    return installment.copy(id: id);
  }

  Future<InstallmentModel> read(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(tableInstallment,
        columns: InstallmentFields.values,
        where: '${InstallmentFields.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return InstallmentModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<InstallmentModel>> readAllInstallments() async {
    final db = await DatabaseHelper.instance.database;
    const orderBy = '${InstallmentFields.createdAt} ASC';
    final result = await db.query(tableInstallment, orderBy: orderBy);
    return result
        .map((balanceJson) => InstallmentModel.fromJson(balanceJson))
        .toList();
  }

  Future<int> update(InstallmentModel installment) async {
    final db = await DatabaseHelper.instance.database;

    return await db.update(
      tableInstallment,
      installment.toJson(),
      where: '${InstallmentFields.id} = ?',
      whereArgs: [installment.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      tableInstallment,
      where: '${InstallmentFields.id} = ?',
      whereArgs: [id],
    );
  }
}
