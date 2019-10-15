import 'package:location/location.dart';

import '../models/user.dart';

import '../resource/user_resource.dart';
import '../provider/user_provider.dart';
import '../utils/token.dart';

class UserService {
  final UserResource _userResource = UserResource();

  final TokenUtil _tokenUtil = TokenUtil();

  Future<void> create(final User user) async{
      await _userResource.createUser(user);
  }

  Future<User> getUser(final String email) async {
    return await _userResource.getUser(email);
  }

  Future<User> getUserLoggedIn() async {
    return await _userResource.getUserLoggedIn();
  }

  void setCurrentUser(final UserProvider userProvider, final User user) {
    userProvider.currentUser = user;
  }

  Future<User> setCurrentUserFromServer(final UserProvider userProvider) async {
    final token = await _tokenUtil.getToken();
    final user = await getUser(token.payload.sub);
    setCurrentUser(userProvider, user);
    return user;
  }
}
