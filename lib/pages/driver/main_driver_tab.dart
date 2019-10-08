import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../routes.dart';
import '../../services/auth_service.dart';

class MainDriverTab extends StatefulWidget {
  @override
  _MainDriverTabState createState() => _MainDriverTabState();
}

class _MainDriverTabState extends State<MainDriverTab> with TickerProviderStateMixin {
  TabController _tabController;
  bool _isScrollable = true;

  final AuthService _authService = AuthService();
  final List<Widget> _myTabs = [
    Container(color: Colors.greenAccent),
    Container(color: Colors.red),
    Container(color: Colors.blue),
  ];

  @override
  void initState() {
    _tabController = TabController(length: _myTabs.length, initialIndex: 0, vsync: this);
    _tabController.addListener(_handleTabChange);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  DefaultTabController build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: Scaffold(
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              onTap: () => print('Implimentar'),
              backgroundColor: Colors.green,
              child: Icon(Icons.add),
              label: 'Novo itinerário'
            ),
            SpeedDialChild(
              onTap: () => _authService.logout(context),
              backgroundColor: Colors.red,
              child: Icon(Icons.close),
              label: 'Sair'
            )
          ],
        ),
        bottomNavigationBar: _buildTabBar(context),
        body: TabBarView(
          controller: _tabController,
          physics: _isScrollable ? null : NeverScrollableScrollPhysics(),
          dragStartBehavior: DragStartBehavior.down,
          children: _myTabs,
        ),
      ),
    );
  }

  TabBar _buildTabBar(BuildContext context) =>
    TabBar(
      controller: _tabController,
      tabs: <Widget>[
        Tab(
          icon: Icon(
            Icons.format_list_bulleted,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.map,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.chat,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );

  void _handleTabChange() {
    if (_tabController.index == 1) {
      setState(() => _isScrollable = false);
    } else {
      setState(() => _isScrollable = true);
    }
  }
}
