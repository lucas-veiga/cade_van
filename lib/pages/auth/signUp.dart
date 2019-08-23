import 'dart:async';

import 'package:flutter/material.dart';
import './driver_tab.dart';
import './responsible_tab.dart';

class SignUp extends StatelessWidget {
  final PageController _pageController;
  final StreamController<bool> _isLoadingStream;

  SignUp(this._pageController, this._isLoadingStream);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.face),
                text: 'Responsável',
              ),
              Tab(
                icon: Icon(Icons.airport_shuttle),
                text: "Transportador",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(child: ResponsibleTab()),
            SingleChildScrollView(child: DriverTab()),
          ],
        ),
      ),
    );
  }
}
