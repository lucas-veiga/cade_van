import 'package:catcher/catcher_plugin.dart';

import '../resource/responsible_resource.dart';
import '../resource/resource_exception.dart';

import '../provider/user_provider.dart';
import './service_exception.dart';

class ResponsibleService {
  ResponsibleResource _responsibleResource = ResponsibleResource();

  static const String DEFAULT_MESSAGE = 'Não foi possivel ';

  Future<void> setMyDrivers(final UserProvider userProvider) async {
    try {
      final list = await _responsibleResource.getMyDrivers();
      userProvider.setMyDrivers(false, drivers: list);
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE pegar seus motoristas', err);
    }
  }
}
