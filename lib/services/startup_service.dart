import 'dart:async';

import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:catcher/core/catcher.dart';

import '../pages/responsible/main_tab.dart';
import '../pages/splash_screen.dart';
import '../pages/auth/main_auth.dart';

import '../provider/child_provider.dart';
import '../provider/user_provider.dart';

import './child_service.dart';
import './responsible_service.dart';
import './auth_service.dart';

import '../widgets/modal.dart';
import '../environments/environment.dart';
import '../utils/application_color.dart';

enum StartupState { BUSY, ERROR, HOME_PAGE, AUTH_PAGE }

class StartUpService {
  final AuthService _authService = AuthService();
  final ResponsibleService _responsibleService = ResponsibleService();
  final ChildService _childService = ChildService();

  final Modal _modal = Modal();
  final Location _location = Location();
  final StreamController<StartupState> startupStatus = StreamController.broadcast();

  Widget handlePageLanding(final BuildContext context, final AsyncSnapshot<StartupState> snap) {
    print('Iniciando handlePageLanding');

      _location.requestPermission()
        .then((hasLocation) {
        if (!hasLocation) {
          _modal.showModal(
            context,
            stringTitle: 'Localização Necessaria',
            stringContent: 'O ${Environment.APP_NAME} precisa acessar sua localização',
            stringTitleColor: ApplicationColorEnum.ERROR,
            actions: _buildActions(context),
          );
        }
      });

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

  List<Widget> _buildActions(final BuildContext context) =>
    <Widget>[
      FlatButton(
        onPressed: () async {
          var has;
          do {
            has = await _location.requestPermission();
            if (has) Navigator.pop(context);
          } while(!has);
        },
        child: Text(
          'OK',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      )
    ];
}
