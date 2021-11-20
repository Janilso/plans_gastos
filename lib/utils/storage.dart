import 'dart:async';
import 'dart:convert';
import 'package:plans_gastos/models/item_balance.dart';
import 'package:plans_gastos/utils/enuns.dart';
import 'package:plans_gastos/utils/formats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enum_to_string/enum_to_string.dart';

class AppStorage {
  static const String balances = 'balances';

  static String getKeyMonth(DateTime month) {
    return AppFormats.dateToFormat(month, 'MMM_yy');
  }

  static Future<bool> save(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, data);
  }

  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<String?> gett(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future<BalanceModel> addBalance(
      BalanceModel balance, String keyMonth) async {
    String? data = await gett(keyMonth);
    String typeToString =
        EnumToString.convertToString(balance.type, camelCase: true);
    final dataMonths = data != null ? json.decode(data)[typeToString] : null;

    final dataSave = json.encode({
      if (data != null) ...json.decode(data),
      // ignore: unnecessary_string_interpolations
      "$typeToString": [...dataMonths ?? [], balanceModelToJson(balance)],
    });
    save(keyMonth, dataSave);
    return balance;
  }

  static Future<dynamic> getBalances(String keyMonth) async {
    final String? data = await gett(keyMonth);
    return data != null ? json.decode(data) : null;
  }

  static Future<dynamic> deleteBalance(
      BalanceModel balance, String keyMonth) async {
    String? data = await gett(keyMonth);
    String typeToString =
        EnumToString.convertToString(balance.type, camelCase: true);
    final dataMonths = data != null ? json.decode(data)[typeToString] : null;

    List<BalanceModel> balances =
        listBalancesModelFromJson(json.encode(dataMonths));
    balances.removeWhere((item) => item.value == balance.value);
    final dataSave = json.encode({
      if (data != null) ...json.decode(data),
      // ignore: unnecessary_string_interpolations
      "$typeToString": [...balances.map((item) => balanceModelToJson(item))],
    });

    save(keyMonth, dataSave);
  }
}
