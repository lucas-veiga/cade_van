import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/user_provider.dart';
import './services/startup_service.dart';
import './stateful_wrapper.dart';
import './routes.dart';
import './config/catcher_config.dart';

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

  @override
  Widget build(BuildContext context) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(
          value: _userProvider,
        ),
      ],
      child: MaterialApp(
        navigatorKey: Catcher.navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: StatefulWrapper(
          onInit: () => _startUpService.beforeAppInit(_userProvider),
          child: StreamBuilder<StartupState>(
            stream: _startUpService.startupStatus.stream,
            builder: (BuildContext ctx, AsyncSnapshot<StartupState> snap) =>
              _startUpService.handlePageLanding(snap),
          ),
        ),
        routes: Routes.availableRoutes,
      ),
    );
}
