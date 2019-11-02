import 'dart:async';

import 'package:flutter/material.dart';

import 'package:catcher/core/catcher.dart';

import '../pages/responsible/main_responsible_tab.dart';
import '../pages/driver/main_driver_tab.dart';
import '../pages/splash_screen.dart';
import '../pages/auth/main_auth.dart';

import '../provider/child_provider.dart';
import '../provider/user_provider.dart';
import '../provider/driver_provider.dart';

import './child_service.dart';
import './user_service.dart';
import './auth_service.dart';
import './service_exception.dart';
import './driver_service.dart';
import './responsible_service.dart';

import '../models/user.dart';

enum StartupState { BUSY, ERROR, HOME_RESPONSIBLE_PAGE, HOME_DRIVER_PAGE, AUTH_PAGE }

class StartUpService {
  final AuthService _authService                     = AuthService();
  final UserService _userService                     = UserService();
  final ChildService _childService                   = ChildService();
  final DriverService _driverService                 = DriverService();
  final ResponsibleService _responsibleService       = ResponsibleService();

  final StreamController<StartupState> startupStatus = StreamController.broadcast();

  Widget handlePageLanding(final BuildContext context, final AsyncSnapshot<StartupState> snap) {
    switch (snap.data) {
      case StartupState.BUSY:
        return SplashScreen();
      case StartupState.HOME_RESPONSIBLE_PAGE:
        return MainResponsibleTab();
      case StartupState.HOME_DRIVER_PAGE:
        return MainDriverTab();
      case StartupState.AUTH_PAGE:
        return MainAuthPage();
      default:
        return MainAuthPage();
    }
  }

  Future<void> beforeAppInit(final BuildContext context, final UserProvider userProvider, final ChildProvider childProvider, final DriverProvider driverProvider) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      final res = await _authService.canEnter();
      switch (res) {
        case true: {
          await _handleHomePage(context, userProvider, childProvider, driverProvider);
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
      throw ServiceException('Erro ao inicar o aplicativo', err);
    }
  }

  Future<void> _handleHomePage(final BuildContext context, final UserProvider userProvider, final ChildProvider childProvider, final DriverProvider driverProvider) async {
    try {
      final user = await _userService.setCurrentUserFromServer(userProvider);
      if (user.type == UserTypeEnum.RESPONSIBLE) {
        await _childService.setAllChildren(childProvider);
        await _responsibleService.setMyDrivers(userProvider);
        await _authService.initListeningLocation(userProvider, context);
      } else {
        final list = await _driverService.setAllItinerary(driverProvider);
        _authService.initItinerary(list, userProvider, context);
      }

      if (user.type == UserTypeEnum.RESPONSIBLE) {
        startupStatus.add(StartupState.HOME_RESPONSIBLE_PAGE);
      } else if (user.type == UserTypeEnum.DRIVER) {
        startupStatus.add(StartupState.HOME_DRIVER_PAGE);
      } else {
        throw ServiceException('Nenhum UserType encontrado');
      }
      print('Adding HOME PAGE');
    } catch (err, stack) {
      startupStatus.add(StartupState.AUTH_PAGE);
      Catcher.reportCheckedError(err, stack);
    }
  }
}
