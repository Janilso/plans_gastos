import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plans_gastos/models/item_balance.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/theme/app_text_styles.dart';
import 'package:plans_gastos/utils/enuns.dart';
import 'package:plans_gastos/utils/formats.dart';
import 'package:plans_gastos/utils/storage.dart';
import 'package:plans_gastos/widgets/add_edit_balance.dart';
import 'package:plans_gastos/widgets/detail_month.dart';
import 'package:plans_gastos/widgets/infinite_tab_view.dart';
// import 'package:plans_gastos/utils/mocks.dart';
import 'package:plans_gastos/widgets/app_bar.dart';
import "package:plans_gastos/utils/string_extension.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DateTime dateNow = DateTime.now();
  List<DateTime> months = [];
  int initialNextsPrevsMonths = 12;
  late int actualIndex;
  // List<BalanceModel> mockBalances = Mocks.mockListItemBalice;
  TypeBalance typeBalancePage = TypeBalance.inputs;

  @override
  void initState() {
    super.initState();
    months = [
      ...getMoths(initialNextsPrevsMonths, dateNow, prev: true),
      dateNow,
      ...getMoths(initialNextsPrevsMonths, dateNow)
    ];
    actualIndex = months.indexWhere((date) =>
        date.year == dateNow.year &&
        date.month == dateNow.month &&
        date.day == dateNow.day);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getMoths(int quantidade, DateTime date,
      {bool prev = false, int skipMonths = 0}) {
    List<DateTime> newMonths = [];

    for (int i = 1; i <= quantidade; i++) {
      DateTime newDate = DateTime(
          date.year,
          prev ? date.month - (skipMonths + i) : date.month + (skipMonths + i),
          date.day);
      prev ? newMonths.insert(0, newDate) : newMonths.add(newDate);
    }
    return newMonths;
  }

  void _handleChangeMonth([int index = 0]) {
    List<DateTime> newMonths = months;
    int newInitialIndex = index;
    DateTime actualMonth = months[index];
    bool isChange = index == (months.length - 4);

    if (isChange) {
      newMonths = [
        ...months,
        ...(index == (months.length - 4)
            ? getMoths(
                initialNextsPrevsMonths,
                months[months.length - 1],
              )
            : [])
      ];
      newInitialIndex = newMonths.indexWhere((date) =>
          date.year == actualMonth.year &&
          date.month == actualMonth.month &&
          date.day == actualMonth.day);
    }
    setState(() {
      months = newMonths;
      actualIndex = newInitialIndex;
      typeBalancePage = TypeBalance.inputs;
    });
  }

  void _handleChangeBalance(TypeBalance typeBalance) {
    setState(() {
      typeBalancePage = typeBalance;
    });
  }

  void _handleAddBalance(TypeBalance typeBalance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) => AddEditBalanceWidget(
        typeBalance: typeBalance,
        actualMonth: months[actualIndex],
        onAdded: () {
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDanger = typeBalancePage == TypeBalance.outputs;
    String titlePage = isDanger ? 'GASTOS' : 'GANHOS';
    Color colorState = isDanger ? AppColors.secondary : AppColors.primary;

    return Scaffold(
      appBar: AppBarWidget(
        title:
            "$titlePage - ${AppFormats.dateToFormat(months[actualIndex]).capitalize()}",
        isDanger: isDanger,
      ),
      body: Container(
        color: colorState,
        child: InfiniteTabView(
          initialIndex: actualIndex,
          length: months.length,
          buildTabBar: (_, index) {
            String date =
                AppFormats.dateToFormat(months[index], 'MMM/yy').toUpperCase();
            return Text(date);
          },
          buildTabView: (_, index) {
            return FutureBuilder(
                future: AppStorage.getBalances(
                    AppStorage.getKeyMonth(months[actualIndex])),
                builder: (ctx, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occured',
                        style:
                            AppTextStyles.h6Regular(color: AppColors.secondary),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data as dynamic;
                    final typeInput =
                        EnumToString.convertToString(TypeBalance.inputs)
                            .capitalize();
                    final typeOutput =
                        EnumToString.convertToString(TypeBalance.outputs)
                            .capitalize();
                    final dataInput = data["$typeInput"];
                    final dataOutput = data["$typeOutput"];

                    List<BalanceModel> balancesInputsMonths = dataInput != null
                        ? listBalancesModelFromJson(json.encode(dataInput))
                        : [];
                    List<BalanceModel> balancesOutputsMonths =
                        dataOutput != null
                            ? listBalancesModelFromJson(json.encode(dataOutput))
                            : [];

                    return DetailMonthWidget(
                      inputBalances: balancesInputsMonths,
                      outputBalances: balancesOutputsMonths,
                      actualMonth: months[actualIndex],
                      onChangePage: _handleChangeBalance,
                    );
                  }
                  return DetailMonthWidget(
                    actualMonth: months[actualIndex],
                    onChangePage: _handleChangeBalance,
                    inputBalances: const [],
                    outputBalances: const [],
                  );
                });
          },
          onChangePage: _handleChangeMonth,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAddBalance(typeBalancePage),
        child: const Icon(Icons.add),
        backgroundColor: colorState,
      ),
    );
  }
}
