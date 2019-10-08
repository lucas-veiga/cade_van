import 'dart:async';

import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:catcher/core/catcher.dart';

import '../pages/responsible/main_responsible_tab.dart';
import '../pages/driver/main_driver_tab.dart';
import '../pages/splash_screen.dart';
import '../pages/auth/main_auth.dart';

import '../provider/child_provider.dart';
import '../provider/user_provider.dart';

import './child_service.dart';
import './user_service.dart';
import './auth_service.dart';
import './service_exception.dart';

import '../models/user.dart';
import '../widgets/modal.dart';
import '../environments/environment.dart';
import '../utils/application_color.dart';

enum StartupState { BUSY, ERROR, HOME_RESPONSIBLE_PAGE, HOME_DRIVER_PAGE, AUTH_PAGE }

class StartUpService {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final ChildService _childService = ChildService();

  final Modal _modal = Modal();
  final Location _location = Location();
  final StreamController<StartupState> startupStatus = StreamController.broadcast();

  Widget handlePageLanding(final BuildContext context, final AsyncSnapshot<StartupState> snap) {
    print('Iniciando handlePageLanding');
    _requestPermission(context);
    switch (snap.data) {
      case StartupState.BUSY:
        print('SETTING SPLASH SCREEN');
        return SplashScreen();
      case StartupState.HOME_RESPONSIBLE_PAGE:
        print('SETTING HOME PAGE');
        return MainResponsibleTab();
      case StartupState.HOME_DRIVER_PAGE:
        return MainDriverTab();
      case StartupState.AUTH_PAGE:
        print('SETTING AUTH PAGE');
        return MainAuthPage();
      default:
        return MainAuthPage();
    }
  }

  Future<void> beforeAppInit(final UserProvider userProvider, final ChildProvider childProvider) async {
    print('Iniciando beforeAppInit');
    startupStatus.add(StartupState.BUSY);
//    await Future.delayed(Duration(seconds: 5));
    try {
      final res = await _authService.canEnter();
      switch (res) {
        case true: {
          await _handleHomePage(userProvider, childProvider);
          break;
        }
        case false: {
          startupStatus.add(StartupState.AUTH_PAGE);
          print('Adding AUTH PAGE - false');
          break;
        }
        default: {
          startupStatus.add(StartupState.AUTH_PAGE);
          print('Adding AUTH PAGE - default');
          break;
        }
      }
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('Erro ao inicar o aplicativo', err);
    }
  }

  void _requestPermission(final BuildContext context) =>
    _location.requestPermission()
      .then((hasLocation) {
      if (!hasLocation) {
        _modal.showModal(
          context,
          stringTitle: 'Localização Necessaria',
          stringContent: 'O ${Environment.APP_NAME} precisa acessar sua localização',
          stringTitleColor: ApplicationColorEnum.WARNING,
          actions: _buildAction(context),
        );
      }
    }).catchError((err) {
      Catcher.reportCheckedError(err, 'NostackTrace');
      throw ServiceException('Nao foi possivel pedir a localizacao ao usuario', err);
    });

  List<Widget> _buildAction(final BuildContext context) =>
    <Widget>[
      FlatButton(
        onPressed: () async => await _handleActionPressed(context),
        child: Text(
          'OK',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      )
    ];

  Future<void> _handleActionPressed(final BuildContext context) async {
    int attempts = 0;
    final int maxAttempt = 3;

    try {
      bool has = false;
      do {
        print('Iniciando $attempts tentativa para pedir localizacao');
        has = await _location.requestPermission();
        if (has) {
          Navigator.pop(context);
          return;
        } else {
          attempts++;
        }
      } while(!has && attempts <= maxAttempt);

      if (!has && attempts >= maxAttempt) {
        _modal.showModal(
          context,
          stringTitle: 'Erro ao pegar a localização',
          stringTitleColor: ApplicationColorEnum.ERROR,
          stringContent: 'Limite máximo de tentativas excedido',
        );
      }
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('Nao foi possivel pedir a localizacao ao usuario', err);
    }
  }

  Future<void> _handleHomePage(final UserProvider userProvider, final ChildProvider childProvider) async {
    try {
      final userLocation = await _location.getLocation();
      final user = await _userService.setCurrentUserFromServer(userProvider, userLocation: userLocation);
      await _childService.setAllChildren(childProvider);

      if (user.type == UserTypeEnum.RESPONSIBLE) {
        startupStatus.add(StartupState.HOME_RESPONSIBLE_PAGE);
      } else if (user.type == UserTypeEnum.DRIVER) {
        startupStatus.add(StartupState.HOME_DRIVER_PAGE);
      } else {
        throw ServiceException('Nenhum UserType encontrado');
      }
      print('Adding HOME PAGE');
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
    }
  }
}
