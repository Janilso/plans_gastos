import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/utils/infinite_tab_view.dart';
import 'package:plans_gastos/widgets/custom_app_bar.dart';
import "package:plans_gastos/utils/string_extension.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DateTime dateNow = DateTime.now();
  String dateNowFormat =
      DateFormat('MMMM yyyy', 'pt_BR').format(DateTime.now());

  List<DateTime> months = [];
  int initialNextsPrevsMonths = 12;
  late int initialIndex;

  @override
  void initState() {
    super.initState();
    months = [
      ...getMoths(initialNextsPrevsMonths, dateNow, prev: true),
      dateNow,
      ...getMoths(initialNextsPrevsMonths, dateNow)
    ];
    initialIndex = months.indexWhere((date) =>
        date.year == dateNow.year &&
        date.month == dateNow.month &&
        date.day == dateNow.day);
  }

  @override
  void dispose() {
    super.dispose();
  }

  TabController getTabController(List<DateTime> newMonths,
      {int? initialIndex}) {
    return initialIndex != null
        ? TabController(
            length: newMonths.length,
            vsync: this,
            initialIndex: initialIndex,
          )
        : TabController(
            length: newMonths.length,
            vsync: this,
          );
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
      int newInitialIndex = newMonths.indexWhere((date) =>
          date.year == actualMonth.year &&
          date.month == actualMonth.month &&
          date.day == actualMonth.day);

      setState(() {
        months = newMonths;
        initialIndex = newInitialIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "ENTRADAS -  ${dateNowFormat.capitalize()}"),
      body: Container(
        color: AppColors.primary,
        child: InfiniteTabView(
          initialIndex: initialIndex,
          length: months.length,
          buildTabBar: (_, index) {
            String date = DateFormat('MMM/yy', 'pt_BR')
                .format(months[index])
                .toUpperCase();
            return Text(date);
          },
          buildTabView: (_, index) {
            return const Center(
              child: Text(
                'This is  tab',
                style: TextStyle(fontSize: 36),
              ),
            );
          },
          onChangePage: _handleChangeMonth,
        ),
      ),
    );
  }
}
