import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plans_gastos/widgets/custom_tab_bar_view_scroll_physics.dart';

// typedef WidgetBuilder = String Function(BuildContext context, int index);

class InfiniteTabView extends StatefulWidget {
  final int length;
  final int initialIndex;
  final Text Function(BuildContext context, int index)? buildTabBar;
  final Widget Function(BuildContext context, int index)? buildTabView;
  final void Function(int index)? onChangePage;

  const InfiniteTabView({
    Key? key,
    required this.length,
    this.initialIndex = 0,
    this.buildTabBar,
    this.buildTabView,
    this.onChangePage,
  }) : super(key: key);

  @override
  _InfiniteTabViewState createState() => _InfiniteTabViewState();
}

class _InfiniteTabViewState extends State<InfiniteTabView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        getTabController(widget.length, initialIndex: widget.initialIndex);
  }

  @override
  void didUpdateWidget(covariant InfiniteTabView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.length != widget.length ||
        oldWidget.initialIndex != widget.initialIndex) {
      _tabController =
          getTabController(widget.length, initialIndex: widget.initialIndex);
      setState(() {});
    }
  }

  TabController getTabController(length, {int initialIndex = 0}) {
    return TabController(
      length: length,
      vsync: this,
      initialIndex: initialIndex,
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
      length: widget.length,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: List.generate(
              widget.length,
              (index) {
                return Tab(
                  icon: widget.buildTabBar!(context, index),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const CustomTabBarViewScrollPhysics(),
              children: List.generate(
                widget.length,
                (index) {
                  return widget.buildTabView!(context, index);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
