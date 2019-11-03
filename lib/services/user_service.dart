import 'package:catcher/core/catcher.dart';

import '../resource/user_resource.dart';
import '../resource/resource_exception.dart';

import '../models/user.dart';
import '../provider/user_provider.dart';
import '../utils/token.dart';
import './service_exception.dart';

class UserService {
  final UserResource _userResource = UserResource();

  static const String DEFAULT_MESSAGE = 'Não foi possivel ';
  final TokenUtil _tokenUtil = TokenUtil();

  Future<void> create(final User user, [final bool delay = false]) async {
    if (delay) {
      await Future.delayed(Duration(seconds: 3));
    }

    try {
      await _userResource.createUser(user);
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE criar a conta', err);
    }
  }

  Future<User> getUser(final String email) async {
    try {
      return await _userResource.getUser(email);
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE pegar o seu usuario', err);
    }
  }

  Future<User> getUserLoggedIn() async {
    try {
      return await _userResource.getUserLoggedIn();
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE pegar o seu usuario logado', err);
    }
  }

  void setCurrentUser(final UserProvider userProvider, final User user) {
    userProvider.currentUser = user;
  }

  Future<User> setCurrentUserFromServer(final UserProvider userProvider) async {
    try {
      final token = await _tokenUtil.getToken();
      final user = await getUser(token.payload.sub);
      setCurrentUser(userProvider, user);
      return user;
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE carregar usuario do servidor', err);
    }
  }
}
