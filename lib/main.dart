import 'package:flutter/material.dart';

import './pages/auth/main_auth.dart';
import './routes.dart';

void main() => runApp(CadeVan());

class CadeVan extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MainAuthPage(),
      routes: Routes.availableRoutes,
    );
  }
}
