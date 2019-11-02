import 'package:flutter/material.dart';

import 'package:catcher/core/catcher.dart';
import 'package:provider/provider.dart';

import './provider/user_provider.dart';
import './provider/child_provider.dart';
import './provider/driver_provider.dart';

import './services/startup_service.dart';
import './stateful_wrapper.dart';
import 'services/routes_service.dart';
import './config/catcher_config.dart';
import './utils/application_color.dart';

void main() {
  CatcherConfig config = CatcherConfig();
  Catcher(
    CadeVan(),
    debugConfig: config.debugConfig(),
    profileConfig: config.debugConfig(),
    releaseConfig: config.releaseConfig(),
    enableLogger: true,
  );
}

class CadeVan extends StatelessWidget {
  final StartUpService _startUpService = StartUpService();

  final UserProvider _userProvider = UserProvider();
  final ChildProvider _childProvider = ChildProvider();
  final DriverProvider _driverProvider = DriverProvider();

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ChildProvider>.value(
          value: _childProvider,
        ),
        ChangeNotifierProvider<UserProvider>.value(
          value: _userProvider,
        ),
        ChangeNotifierProvider<DriverProvider>.value(
          value: _driverProvider,
        ),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: ApplicationColor.MAIN,
        ),
        home: StatefulWrapper(
          onInit: () => _startUpService.beforeAppInit(_navigatorKey.currentState.overlay.context, _userProvider, _childProvider, _driverProvider),
          child: StreamBuilder<StartupState>(
            stream: _startUpService.startupStatus.stream,
            initialData: StartupState.BUSY,
            builder: (BuildContext ctx, AsyncSnapshot<StartupState> snap) =>
              _startUpService.handlePageLanding(ctx, snap),
          ),
        ),
        routes: RoutesService.availableRoutes,
      ),
    );
}
