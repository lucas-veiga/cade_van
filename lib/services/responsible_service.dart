import 'package:location/location.dart';

import '../models/user.dart';
import '../utils/token.dart';
import '../resource/responsible_resource.dart';
import '../provider/user_provider.dart';

class ResponsibleService {
  final TokenUtil _tokenUtil = TokenUtil();
  final ResponsibleResource _resource = ResponsibleResource();

  Future<void> setCurrentUser(final UserProvider userProvider, { final LocationData userLocation }) async {
    final user = await _getResponsibleLoggedIn();
    user.userLocation = userLocation;
    userProvider.currentUser = user;
  }

  Future<User> _getResponsibleLoggedIn() async {
    final token = await _tokenUtil.getToken();
    return await _resource.getResponsible(token.payload.sub);
  }

}
