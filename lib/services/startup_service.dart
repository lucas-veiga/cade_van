import 'dart:async';

import 'package:cade_van/services/child_service.dart';
import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';

import '../pages/main_tab.dart';
import '../pages/splash_screen.dart';
import '../pages/auth/main_auth.dart';

import '../provider/child_provider.dart';
import '../provider/user_provider.dart';

import './auth_service.dart';
import '../services/responsible_service.dart';

enum StartupState { BUSY, ERROR, HOME_PAGE, AUTH_PAGE }

class StartUpService {
  final StreamController<StartupState> startupStatus = StreamController.broadcast();
  final AuthService _authService = AuthService();
  final ResponsibleService _responsibleService = ResponsibleService();
  final ChildService _childService = ChildService();

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

  Future<void> beforeAppInit(final UserProvider userProvider, final ChildProvider childProvider) async {
    startupStatus.add(StartupState.BUSY);
//    await Future.delayed(Duration(seconds: 5));
    try {
      final res = await _authService.canEnter();
      switch (res) {
        case true: {
          await _responsibleService.setCurrentUser(userProvider);
          await _childService.setAllChildren(childProvider);
          startupStatus.add(StartupState.HOME_PAGE);
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
