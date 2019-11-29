import 'package:flutter/material.dart';

import 'package:catcher/core/catcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../provider/child_provider.dart';
import '../provider/driver_provider.dart';

import '../models/token.dart';
import '../models/user.dart';
import '../models/itinerary.dart';

import './user_service.dart';
import './child_service.dart';
import './service_exception.dart';
import './responsible_service.dart';
import './driver_service.dart';
import './socket_location_service.dart';

import '../resource/resource_exception.dart';
import '../resource/auth_resource.dart';

import '../socket/socket_exception.dart';
import './routes_service.dart';

class AuthService {
  final UserService _userService                = UserService();
  final ChildService _childService              = ChildService();
  final AuthResource _authResource              = AuthResource();
  final ResponsibleService _responsibleService  = ResponsibleService();
  final DriverService _driverService            = DriverService();

  static const String DEFAULT_MESSAGE = 'Não foi possivel ';

  Future<void> login(final User user, final BuildContext context, [final bool delay = false]) async {
    if (delay) {
      await Future.delayed(Duration(seconds: 3));
    }
    try {
      await _handleToken(user);
      final userFromServer = await _handleUser(context);
      _userService.handleDeviceToken();
      _handleHomePage(userFromServer, context);
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE realizar login', err);
    }
  }

  Future<void> logout(final BuildContext context) async {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final ChildProvider childProvider = Provider.of<ChildProvider>(context, listen: false);
    final DriverProvider driverProvider = Provider.of<DriverProvider>(context, listen: false);

    try {
      final preferences = await SharedPreferences.getInstance();
      final res = await preferences.remove(Token.TOKEN_KEY);
      if (res) {
        userProvider.logout();
        childProvider.logout();
        driverProvider.logout();
        if (SocketLocationService.isConnected(false)) {
          SocketLocationService.close();
        }
        Navigator.pushReplacementNamed(context, RoutesService.AUTH_PAGE);
      } else {
        throw ServiceException('$DEFAULT_MESSAGE navegar para pagina de login');
      }
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE sair conta', err);
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
      throw ServiceException('$DEFAULT_MESSAGE verificar o JWT', err);
    }
  }

  Future<void> initListeningLocation(final UserProvider userProvider, final BuildContext context) async {
    try {
      await SocketLocationService.init(userProvider);
      SocketLocationService.listenLocation(context);
    } on SocketException catch(err) {
      throw ServiceException(err.msg, err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE iniciar compartilhamento da localização', err);
    }
  }

  Future<void> initItinerary(final List<Itinerary> list, final UserProvider userProvider, final BuildContext context) async{
    try {
      final hasItineraryActivated = list.any((item) => item.isAtivo == true);
      if (hasItineraryActivated) {
        await _driverService.checkGPSPermission(context);
        final isConnected = SocketLocationService.isConnected(false);
        final itineraryActivated = list.singleWhere((item) => item.isAtivo == true);
        if (isConnected) {
          SocketLocationService.close();
        }
        await SocketLocationService.init(userProvider, itineraryActivated);
        SocketLocationService.sendLocation();
        await _childService.updateStatusWaiting(itineraryActivated.id);
      }
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } on SocketException catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE iniciar o socket', err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE iniciar o itinerário', err);
    }
  }

  Future<void> _handleToken(final User user) async {
    final token = await _authResource.login(user);
    final tokenJSON = Token.toJSON(token);
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(Token.TOKEN_KEY, tokenJSON);
  }

  Future<User> _handleUser(final BuildContext context) async {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final ChildProvider childProvider = Provider.of<ChildProvider>(context, listen: false);
    final DriverProvider driverProvider = Provider.of<DriverProvider>(context, listen: false);

    final user = await _userService.getUserLoggedIn();
    _userService.setCurrentUser(userProvider, user);

    if (user.type == UserTypeEnum.RESPONSIBLE) {
      await _childService.setAllChildren(childProvider);
      await _responsibleService.setMyDrivers(userProvider);
      await initListeningLocation(userProvider, context);
    } else {
      final list = await _driverService.setAllItinerary(driverProvider);
      await _driverService.setMyResponsible(userProvider);
      initItinerary(list, userProvider, context);
    }
    return user;
  }

  void _handleHomePage(final User userFromServer, final BuildContext context) async {
//    _fcm?.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
////         TODO optional
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
////         TODO optional
//      },
//    );

    if (userFromServer.type == UserTypeEnum.RESPONSIBLE) {
      Navigator.pushReplacementNamed(context, RoutesService.HOME_RESPONSIBLE_PAGE);
    } else if (userFromServer.type == UserTypeEnum.DRIVER) {
      Navigator.pushReplacementNamed(context, RoutesService.HOME_DRIVER_PAGE);
    } else {
      throw ServiceException('UserType Not Found');
    }
  }
}
