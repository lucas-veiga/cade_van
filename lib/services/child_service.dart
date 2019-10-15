import '../models/child.dart';
import '../resource/child_resource.dart';
import '../provider/child_provider.dart';

class ChildService {
  final ChildResource _childResource = ChildResource();

  Future<void> saveChild(final Child child) async {
    await _childResource.saveChild(child);
  }

  Future<void> setAllChildren(final ChildProvider childProvider) async {
    final children = await _childResource.getAllChildren();
    childProvider.emptyChildren();
    childProvider.addAll = children;
  }
}
