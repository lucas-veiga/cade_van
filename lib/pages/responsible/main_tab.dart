import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import './home_tab.dart';
import './map_tab.dart';

import '../../routes.dart';
import '../../services/auth_service.dart';

class MainTab extends StatelessWidget {
  final AuthService _authService = AuthService();
  
  @override
  DefaultTabController build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
          children: <Widget>[
            HomeTab(),
            MapTab(),
            Container(color: Colors.amber),
          ],
        ),
      ),
    );
  }

  TabBar _buildTabBar(BuildContext context) =>
    TabBar(
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
}
