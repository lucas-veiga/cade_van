import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: FlareActor(
        'assets/flare/loading_circle.flr',
        animation: 'Untitled',
      ),
    );
  }
}
