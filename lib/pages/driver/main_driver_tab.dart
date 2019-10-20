import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/driver_service.dart';
import '../../services/routes_service.dart';

import '../../provider/driver_provider.dart';
import './home_driver_tab.dart';
import '../../models/itinerary.dart';

class MainDriverTab extends StatefulWidget {
  @override
  _MainDriverTabState createState() => _MainDriverTabState();
}

class _MainDriverTabState extends State<MainDriverTab> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final DriverService _driverService = DriverService();
  final RoutesService _routesService = RoutesService();

  TabController _tabController;

  final List<Widget> _myTabs = [
    HomeDriverPage(),
    Container(color: Colors.blue),
  ];

  @override
  void initState() {
    _tabController = TabController(length: _myTabs.length, initialIndex: 0, vsync: this);
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
        floatingActionButton: Consumer<DriverProvider>(
          builder: (_, final DriverProvider provider, __) =>
            SpeedDial(itinerary.description
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: _isSharing(provider.itinerary) ? Colors.orange : null,
              children: [
                SpeedDialChild(
                  onTap: () => _onStarDriving(),
                  backgroundColor: _isSharing(provider.itinerary) ? Colors.orange : null,
                  child: Icon(_isSharing(provider.itinerary) ? Icons.gps_off : Icons.gps_fixed),
                  label: _isSharing(provider.itinerary) ? 'Parar Viagem' : 'Iniciar Viagem',
                ),
                SpeedDialChild(
                  onTap: _onCreatingItinerary,
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
        ),
        bottomNavigationBar: _buildTabBar(context),
        body: TabBarView(
          controller: _tabController,
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

  bool _isSharing(final List<Itinerary> list) =>
    list.any((item) => item.isAtivo == true);

  void _onStarDriving() {

    print('\n\n\tFAZER ISSO\n\n');
//    if (provider.isDriving) {
//      SocketLocationService.init(provider);
//      SocketLocationService.sendLocation();
//    } else {
//      SocketLocationService.sendLocation(true);
//      Future.delayed(Duration(seconds: 1), SocketLocationService.close);
//    }
  }

  Future<void> _onCreatingItinerary() async {
    final children = await _driverService.findMyChildren();
    _routesService.goToItineraryFormPage(context, children);

  }
}
