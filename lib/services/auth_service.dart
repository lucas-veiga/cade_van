import 'package:flutter/material.dart';

import 'package:catcher/core/catcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../provider/child_provider.dart';

import '../models/token.dart';
import '../models/user.dart';

import './user_service.dart';
import './child_service.dart';
import './service_exception.dart';

import '../resource/auth_resource.dart';
import './routes_service.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final UserService _userService    = UserService();
  final ChildService _childService  = ChildService();
  final AuthResource _authResource  = AuthResource();

  final FirebaseMessaging _fcm      = FirebaseMessaging();

  Future<void> login(final User user, final BuildContext context) async {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final ChildProvider childProvider = Provider.of<ChildProvider>(context, listen: false);

    try {
      await _handleToken(user);
      final userFromServer = await _handleUser(userProvider, childProvider, user);
      _handleHomePage(userFromServer, context);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('Error ao realizar login');
    }
  }

  Future<void> logout(final BuildContext context) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final res = await preferences.remove(Token.TOKEN_KEY);
      if (res) {
        Navigator.pushReplacementNamed(context, RoutesService.AUTH_PAGE);
      } else {
        throw ServiceException('Não foi possível navegar para AUTH_PAGE');
      }
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('Error ao sair conta');
    }
  }

  Future<bool> canEnter() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final tokenStr = preferences.getString(Token.TOKEN_KEY);
      if (tokenStr == null) return false;
      final token = Token(tokenStr);
      return token.payload.exp.isAfter(DateTime.now());
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('Error ao verificar o token');
    }
  }

  Future<void> _handleToken(final User user) async {
    final token = await _authResource.login(user);
    final tokenJSON = Token.toJSON(token);
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(Token.TOKEN_KEY, tokenJSON);
  }

  Future<User> _handleUser(final UserProvider userProvider, final ChildProvider childProvider, final User user) async {
    final userFromServer = await _userService.getUserLoggedIn();
    _userService.setCurrentUser(userProvider, user);
    await _childService.setAllChildren(childProvider);
    return userFromServer;
  }

  void _handleHomePage(final User userFromServer, final BuildContext context) async {

    String fcmToken = await _fcm.getToken();
    print('TOKENNNNNNNNNNNNNNNNNNN' + fcmToken);
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//         TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
//         TODO optional
      },
    );
    if (userFromServer.type == UserTypeEnum.RESPONSIBLE) {
      Navigator.pushReplacementNamed(context, RoutesService.HOME_RESPONSIBLE_PAGE);
    } else if (userFromServer.type == UserTypeEnum.DRIVER) {
      Navigator.pushReplacementNamed(context, RoutesService.HOME_DRIVER_PAGE);
    } else {
      throw ServiceException('UserType Not Found');
    }

  }
}
