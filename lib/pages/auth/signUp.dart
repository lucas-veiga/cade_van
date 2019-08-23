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
                icon: Icon(Icons.drive_eta),
                text: 'Responsável',
              ),
              Tab(
                icon: Icon(Icons.card_travel),
                text: "Transportador"
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ResponsibleTab(),
            DriverTab(),
          ],
        ),
      ),
    );
  }
}
