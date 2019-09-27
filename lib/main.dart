import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: StatefulWrapper(
        onInit: _startUpService.beforeAppInit,
        child: StreamBuilder<StartupState>(
          stream: _startUpService.startupStatus.stream,
          builder: (BuildContext ctx, AsyncSnapshot<StartupState> snap) =>
            _startUpService.handlePageLanding(snap),
        ),
      ),
      routes: Routes.availableRoutes,
    );
  }
}
