import 'package:plans_gastos/utils/formats.dart';

class AppValidations {
  static String? email(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return !regex.hasMatch(value ?? '')
        ? 'Por favor, insira um email válido.'
        : null;
  }

  static String? celular(String? value) {
    return value != null && value.length != 15
        ? 'Por favor, preencha corretamente este campo.'
        : null;
  }

  static String? cep(String? value) {
    return value != null && value.length != 10
        ? 'Por favor, preencha corretamente este campo.'
        : null;
  }

  static String? money(String? value) {
    if (value == null) return null;
    double valeuParse = AppFormats.stringMoneyToDouble(value);

    return valeuParse <= 0
        ? '    Por favor, preencha com um valor acima de R\$ 0,00.'
        : null;
  }

  static String? defaultValidate(String? value) {
    return value != null && value.isEmpty
        ? '              Por favor, preencha corretamente este campo.'
        : null;
  }
}
