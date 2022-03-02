import 'package:path/path.dart';
import 'package:plans_gastos/models/Installment.dart';
import 'package:plans_gastos/models/balance.dart';
import 'package:sqflite/sqflite.dart';

class BalancesDatabase {
  static final BalancesDatabase instance = BalancesDatabase._init();

  static Database? _database;

  BalancesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('$tableBalances.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const pkType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const fpkType = 'FOREIGN KEY';
    const boolType = 'BOOLEAN NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const stringType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE $tableBalances (
  ${BalanceFields.id} $pkType, 
  ${BalanceFields.title} $pkType,
  ${BalanceFields.value} $doubleType,
  ${BalanceFields.numbersInstallment} $intType,
  ${BalanceFields.type} $stringType,
  ${BalanceFields.date} $stringType,
  ${BalanceFields.createdAt} $stringType,
  ${BalanceFields.updatedAt} $stringType,
  )
''');

    await db.execute('''
CREATE TABLE $tableInstallment (
  ${InstallmentFields.id} $pkType, 
  ${InstallmentFields.value} $doubleType, 
  ${InstallmentFields.number} $intType, 
  ${InstallmentFields.realized} $boolType, 
  ${BalanceFields.createdAt} $stringType,
  ${BalanceFields.updatedAt} $stringType,
  ${InstallmentFields.idBalance} $intType, 
  $fpkType (${InstallmentFields.idBalance}) REFERENCES $tableBalances (${BalanceFields.id})
  )
''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
