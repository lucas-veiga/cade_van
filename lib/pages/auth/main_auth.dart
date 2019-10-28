import 'dart:async';

import 'package:flutter/material.dart';

import './landing.dart';
import './signIn.dart';
import './signUp.dart';

class MainAuthPage extends StatefulWidget {
  static final int landPage = 1, signIn = 0, signUp = 2;

  @override
  _MainAuthPageState createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  static final PageController _pageController =
  PageController(initialPage: MainAuthPage.landPage);

  StreamController<bool> _isLoadingStream;
  List<Widget> _pages;

  @override
  void initState() {
    _isLoadingStream = StreamController<bool>.broadcast();
    _pages = [
      SignIn(_pageController, _isLoadingStream),
      LandingPage(_pageController),
      SignUp(_pageController, _isLoadingStream),
    ];

    super.initState();
  }
  @override
  void dispose() {
    _isLoadingStream?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: StreamBuilder(
        stream: _isLoadingStream.stream,
        builder: (_, snap) => _loadPageView(snap),
      ),
    );
  }

  PageView _loadPageView(AsyncSnapshot<bool> snap) {
    return PageView(
      physics: snap.hasData && snap.data
        ? NeverScrollableScrollPhysics()
        : BouncingScrollPhysics(),
      controller: _pageController,
      children: _pages,
    );
  }
}
