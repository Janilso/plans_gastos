import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:plans_gastos/models/item_balance.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/utils/formats.dart';
import 'package:plans_gastos/widgets/balance_tab_view.dart';
import 'package:plans_gastos/widgets/infinite_tab_view.dart';
import 'package:plans_gastos/utils/mocks.dart';
import 'package:plans_gastos/widgets/app_bar.dart';
import "package:plans_gastos/utils/string_extension.dart";
import 'package:plans_gastos/widgets/resume_money.dart';

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
  List<ItemBalance> mockBalances = Mocks.mockListItemBalice;
  bool isDanger = false;

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
    late final List<DateTime> newMonths;
    int newInitialIndex = index;
    DateTime actualMonth = months[index];
    bool isChange = index == (months.length - 4);

    if (isChange) {
      newMonths = [
        ...months,
        ...index == (months.length - 4)
            ? getMoths(
                initialNextsPrevsMonths,
                actualMonth,
                skipMonths: initialNextsPrevsMonths - 1,
              )
            : []
      ];
      newInitialIndex = newMonths.indexWhere((date) =>
          date.year == actualMonth.year &&
          date.month == actualMonth.month &&
          date.day == actualMonth.day);
    }
    setState(() {
      if (isChange) {
        months = newMonths;
      }
      actualIndex = newInitialIndex;
    });
  }

  void _handleChangeBalance(int index) {
    setState(() {
      isDanger = index == 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    String titlePage = isDanger ? 'SAÍDAS' : 'ENTRADAS';
    Color colorState = isDanger ? AppColors.secondary : AppColors.primary;

    return Scaffold(
      appBar: AppBarWidget(
        title:
            "$titlePage - ${AppFormats.dateToMonthNamed(months[actualIndex]).capitalize()}",
        isDanger: isDanger,
      ),
      body: Container(
        color: colorState,
        child: InfiniteTabView(
          initialIndex: actualIndex,
          length: months.length,
          buildTabBar: (_, index) {
            String date = DateFormat('MMM/yy', 'pt_BR')
                .format(months[index])
                .toUpperCase();

            return Text(date);
          },
          buildTabView: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ResumeMoneyWidget(label: 'entradas', value: 1900),
                        ResumeMoneyWidget(label: 'saídas', value: -1800),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Divider(color: AppColors.whiteDesable, thickness: 2),
                  const Center(
                    child: ResumeMoneyWidget(
                      label: 'balanço',
                      value: 100,
                      center: true,
                    ),
                  ),
                  const SizedBox(height: 15),
                  BalanceTabViewWidget(
                    inputBalances: mockBalances,
                    outputBalances: mockBalances,
                    onChangePage: _handleChangeBalance,
                  ),
                ],
              ),
            );
          },
          onChangePage: _handleChangeMonth,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(FeatherIcons.plus),
        backgroundColor: colorState,
      ),
    );
  }
}
