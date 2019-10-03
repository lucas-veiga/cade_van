import '../models/child.dart';
import '../resource/child_resource.dart';

class ChildService {
  final ChildResource _childResource = ChildResource();

  Future<void> saveChild(final Child child, final int responsibleId) async {
    child.responsibleId = responsibleId;
    return await _childResource.saveChild(child);
  }
}
