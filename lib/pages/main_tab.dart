import 'package:flutter/material.dart';

import './home_page.dart';

class MainTab extends StatelessWidget {
  @override
  DefaultTabController build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: _buildTabBar(context),
        body: TabBarView(
          children: <Widget>[
            HomePage(),
            Container(color: Colors.blue),
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
