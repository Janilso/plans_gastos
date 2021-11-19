import 'package:intl/intl.dart';

class AppFormats {
  static String dateToMonthNamed(DateTime date) {
    return DateFormat('MMMM yyyy', 'pt_BR').format(date);
  }

  static String valueToMoney(double value) {
    return NumberFormat.simpleCurrency(locale: 'pt_BR').format(value);
  }
}
