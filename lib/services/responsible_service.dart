import '../models/user.dart';

import '../utils/token.dart';
import '../resource/responsible_resource.dart';
import '../provider/user_provider.dart';

class ResponsibleService {
  final TokenUtil _tokenUtil = TokenUtil();
  final ResponsibleResource _resource = ResponsibleResource();

  Future<void> setCurrentUser(final UserProvider userProvider) async {
    final user = await _getResponsibleLoggedIn();
    userProvider.currentUser = user;
  }

  Future<User> _getResponsibleLoggedIn() async {
    final token = await _tokenUtil.getToken();
    return await _resource.getResponsible(token.payload.sub);
  }

}
