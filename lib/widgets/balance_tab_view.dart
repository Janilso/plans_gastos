import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:plans_gastos/models/item_balance.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/theme/app_text_styles.dart';
import 'package:plans_gastos/utils/enuns.dart';
import 'package:plans_gastos/utils/storage.dart';
import 'package:plans_gastos/widgets/custom_tab_bar_view_scroll_physics.dart';
import 'package:plans_gastos/widgets/item_balance.dart';

class BalanceTabViewWidget extends StatefulWidget {
  final List<BalanceModel> inputBalances;
  final List<BalanceModel> outputBalances;
  final void Function(TypeBalance typeBalance)? onChangePage;
  final DateTime? actualMonth;
  final void Function(BalanceModel balanceRemoved)? onRemoveItem;

  const BalanceTabViewWidget({
    Key? key,
    this.actualMonth,
    this.inputBalances = const [],
    this.outputBalances = const [],
    this.onChangePage,
    this.onRemoveItem,
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
    // _tabController.animation
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  handleChangePage() {
    if (widget.onChangePage != null) {
      widget.onChangePage!(
          _tabController.index == 0 ? TypeBalance.inputs : TypeBalance.outputs);
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
              dragStartBehavior: DragStartBehavior.down,
              isScrollable: true,
              tabs: const [
                Tab(icon: Text('GANHOS')),
                Tab(icon: Text('GASTOS')),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 318,
            margin: const EdgeInsets.only(top: 12),
            child: TabBarView(
              controller: _tabController,
              physics: const CustomTabBarViewScrollPhysics(),
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

  Widget _buildBalances(List<BalanceModel> balances, [bool isOutput = false]) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: balances.length,
          itemBuilder: (_, index) {
            BalanceModel balance = balances[index];
            return Dismissible(
              key: UniqueKey(),
              child: Column(
                children: [
                  ItemBalanceWidget(
                    name: balance.numberInstallments != null &&
                            balance.numberInstallments > 1
                        ? '${balance.title} - ${balance.installment}/${balance.numberInstallments}'
                        : balance.title,
                    value: balance.value,
                    danger: isOutput,
                  ),
                  if (index != balances.length)
                    const Divider(color: AppColors.grayLight, height: 0)
                ],
              ),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(index == 0 ? 16 : 0),
                  ),
                  color: AppColors.secondary,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Excluir", style: AppTextStyles.h6SemiBold()),
                      const SizedBox(width: 8),
                      const Icon(Icons.delete_outline, color: Colors.white),
                    ],
                  ),
                ),
              ),
              onDismissed: (_) {
                if (widget.actualMonth != null) {
                  AppStorage.deleteBalance(
                      balance, AppStorage.getKeyMonth(widget.actualMonth!));
                  widget.onRemoveItem!(balance);
                }
              },
            );
          }),
    );
  }
}
