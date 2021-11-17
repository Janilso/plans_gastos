import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/widgets/custom_app_bar.dart';
import "package:plans_gastos/utils/string_extension.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime dateNow = DateTime.now();
  String dateNowFormat =
      DateFormat('MMMM yyyy', 'pt_BR').format(DateTime.now());

  String _value = '';

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2022));
    if (picked != null) setState(() => _value = picked.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "ENTRADAS -  ${dateNowFormat.capitalize()}",
      ),
      body: Container(
        color: AppColors.primary,
        child: Column(
          children: [
            const Text('Feito'),
            ElevatedButton(
              onPressed: _selectDate,
              child: const Text('CLIQUE'),
            )
          ],
        ),
      ),
    );
  }
}
