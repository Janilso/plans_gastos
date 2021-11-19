import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plans_gastos/models/item_balance.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/widgets/item_balance.dart';

class BalanceTabViewWidget extends StatefulWidget {
  final List<ItemBalance> inputBalances;
  final List<ItemBalance> outputBalances;
  final void Function(int typeBalance)? onChangePage;

  const BalanceTabViewWidget({
    Key? key,
    this.inputBalances = const [],
    this.outputBalances = const [],
    this.onChangePage,
  }) : super(key: key);

  @override
  _BalanceTabViewWidgetState createState() => _BalanceTabViewWidgetState();
}

class _BalanceTabViewWidgetState extends State<BalanceTabViewWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    )..addListener(handleChangePage);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  handleChangePage() {
    if (widget.onChangePage != null) {
      widget.onChangePage!(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Center(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(icon: Text('ENTRADAS')),
                Tab(icon: Text('SAÍDAS')),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 318,
            margin: const EdgeInsets.only(top: 12),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBalances(widget.inputBalances),
                _buildBalances(widget.outputBalances, true),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBalances(List<ItemBalance> balances, [bool isOutput = false]) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          separatorBuilder: (_, __) => const Divider(
                color: AppColors.grayLight,
                height: 5,
              ),
          itemCount: balances.length,
          itemBuilder: (_, index) {
            ItemBalance balance = balances[index];
            return ItemBalanceWidget(
              name: balance.title,
              value: balance.value,
              danger: isOutput,
            );
          }),
    );
  }
}
