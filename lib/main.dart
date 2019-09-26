import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';

import './pages/auth/main_auth.dart';
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MainAuthPage(),
      routes: Routes.availableRoutes,
    );
  }
}
