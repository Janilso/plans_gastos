import 'package:plans_gastos/models/item_balance.dart';
import 'package:uuid/uuid.dart';

class Mocks {
  // var uuid = const Uuid();

  static List<ItemBalance> mockListItemBalice = [
    ItemBalance(
      uuid: const Uuid().v4(),
      title: 'Salário',
      value: 1500,
    ),
    ItemBalance(
      uuid: const Uuid().v4(),
      title: 'Venda da bicicleta',
      value: 400,
    ),
  ];
}
