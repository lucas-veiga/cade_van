import 'dart:async';

import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';

import '../pages/main_tab.dart';
import '../pages/splash_screen.dart';
import '../pages/auth/main_auth.dart';

import './auth_service.dart';
import '../services/responsible_service.dart';

enum StartupState { BUSY, ERROR, HOME_PAGE, AUTH_PAGE }

class StartUpService {
  final StreamController<StartupState> startupStatus = StreamController.broadcast();
  final AuthService _authService = AuthService();
  final ResponsibleService _responsibleService = ResponsibleService();

  Widget handlePageLanding(final AsyncSnapshot<StartupState> snap) {
    print('Iniciando handlePageLanding');

    switch (snap.data) {
      case StartupState.BUSY:
        return SplashScreen();
      case StartupState.AUTH_PAGE:
        return MainAuthPage();
      case StartupState.HOME_PAGE:
        return MainTab();
      default:
        return MainAuthPage();
    }
  }

  Future<void> beforeAppInit() async {
    startupStatus.add(StartupState.BUSY);
//    await Future.delayed(Duration(seconds: 5));
    try {
      final res = await _authService.canEnter();
      switch (res) {
        case true: {
          startupStatus.add(StartupState.HOME_PAGE);
          _responsibleService.getResponsible()
            .then((res) => print('RES -> $res'));
          break;
        }
        case false: {
          startupStatus.add(StartupState.AUTH_PAGE);
          break;
        }
        default: {
          startupStatus.add(StartupState.AUTH_PAGE);
          break;
        }
      }
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
    }
  }
}
