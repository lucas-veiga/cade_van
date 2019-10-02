import '../models/user.dart';

import '../utils/token.dart';
import '../resource/responsible_resource.dart';

class ResponsibleService {
  final TokenUtil _tokenUtil = TokenUtil();
  final ResponsibleResource _resource = ResponsibleResource();

  Future<User> getResponsible() async {
    final token = await _tokenUtil.getToken();
    return await _resource.getResponsible(token.payload.sub);
  }
}
