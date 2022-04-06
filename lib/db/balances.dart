import 'package:plans_gastos/models/balance.dart';
import 'package:plans_gastos/utils/database_helper.dart';

class BalancesDatabase {
  Future<BalanceModel> create(BalanceModel balance) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert(tableBalances, balance.toJson());
    return balance.copy(id: id);
  }

  Future<BalanceModel> read(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(tableBalances,
        columns: BalanceFields.values,
        where: '${BalanceFields.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return BalanceModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<BalanceModel>> readAllBalances() async {
    final db = await DatabaseHelper.instance.database;
    const orderBy = '${BalanceFields.createdAt} ASC';
    final result = await db.query(tableBalances, orderBy: orderBy);
    return result
        .map((balanceJson) => BalanceModel.fromJson(balanceJson))
        .toList();
  }

  Future<int> update(BalanceModel balance) async {
    final db = await DatabaseHelper.instance.database;

    return await db.update(
      tableBalances,
      balance.toJson(),
      where: '${BalanceFields.id} = ?',
      whereArgs: [balance.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      tableBalances,
      where: '${BalanceFields.id} = ?',
      whereArgs: [id],
    );
  }
}
