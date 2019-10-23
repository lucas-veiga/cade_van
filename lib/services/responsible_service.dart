import '../resource/responsible_resource.dart';
import '../provider/user_provider.dart';

class ResponsibleService {
  ResponsibleResource _responsibleResource = ResponsibleResource();

  Future<void> setMyDrivers(final UserProvider userProvider) async {
    final list = await _responsibleResource.getMyDrivers();
    userProvider.setMyDrivers(false, drivers: list);
  }
}
