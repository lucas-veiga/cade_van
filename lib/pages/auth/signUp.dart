import 'dart:async';

import 'package:flutter/material.dart';

import './driver_tab.dart';
import './responsible_tab.dart';
import '../../widgets/block_ui.dart';

class SignUp extends StatelessWidget {
  final PageController _pageController;
  final StreamController<bool> _isLoadingStream;

  SignUp(this._pageController, this._isLoadingStream);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _navigateToLandPage();
        return Future.value(false);
      },
      child: DefaultTabController(
        length: 2,
        child: BlockUI(
          blockUIController: _isLoadingStream,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: _navigateToLandPage ,
                ),
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
            ),
            body: TabBarView(
              children: <Widget>[
                ResponsibleTab(_isLoadingStream),
                DriverTab(_isLoadingStream),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToLandPage() {
    _pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
    );
  }
}
