import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../services/auth_service.dart';
import '../../services/routes_service.dart';

import './home_responsible_tab.dart';
import '../../environments/environment.dart';

class MainResponsibleTab extends StatefulWidget {
  @override
  _MainResponsibleTabState createState() => _MainResponsibleTabState();
}

class _MainResponsibleTabState extends State<MainResponsibleTab> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();

  TabController _tabController;
  bool _isScrollable = true;

  final List<Widget> _myTabs = [
    HomeResponsibleTab(),
    Container(color: Colors.amber),
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
        appBar: AppBar(
          title: Text(
            Environment.APP_NAME,
            style: TextStyle(
              color: Theme.of(context).primaryColor
            ),
          ),
          backgroundColor: Colors.transparent,
          actionsIconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          elevation: 0,
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              onTap: () => Navigator.pushNamed(context, RoutesService.CHILD_FORM),
              backgroundColor: Colors.green,
              child: Icon(Icons.add),
              label: 'Nova Criança'
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
            Icons.home,
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
