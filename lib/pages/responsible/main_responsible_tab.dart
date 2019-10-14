import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


import '../../services/auth_service.dart';
import '../../services/socket_location_service.dart';
import '../../services/driver_service.dart';

import './home_responsible_tab.dart';
import './map_responsible_tab.dart';

import '../../provider/user_provider.dart';
import '../../provider/child_provider.dart';
import '../../provider/driver_provider.dart';

import '../../routes.dart';

class MainResponsibleTab extends StatefulWidget {
  @override
  _MainResponsibleTabState createState() => _MainResponsibleTabState();
}

class _MainResponsibleTabState extends State<MainResponsibleTab> with TickerProviderStateMixin {
  TabController _tabController;
  bool _isScrollable = true;

  final AuthService _authService = AuthService();
  final DriverService _driverService = DriverService();

  final List<Widget> _myTabs = [
    HomeResponsibleTab(),
    MapResponsibleTab(),
    Container(color: Colors.amber),
  ];

  @override
  void initState() {
    _tabController = TabController(length: _myTabs.length, initialIndex: 0, vsync: this);
    _tabController.addListener(_handleTabChange);

    SchedulerBinding.instance.addPostFrameCallback(_initAfterViewCreated);
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
              onTap: () => Navigator.pushNamed(context, Routes.CHILD_FORM),
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
            Icons.child_care,
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

  void _initAfterViewCreated(_) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final child = Provider.of<ChildProvider>(context, listen: false).children.first;
    final driverProvider = Provider.of<DriverProvider>(context);

    _driverService.setMyDrivers(user, child, driverProvider).then((value) {
      SocketLocationService.init(Provider.of<UserProvider>(context, listen: false));
      SocketLocationService.listenLocation(driverProvider);
    });
  }
}
