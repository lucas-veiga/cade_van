import 'package:catcher/core/catcher.dart';

import '../resource/child_resource.dart';
import '../resource/resource_exception.dart';

import '../models/child.dart';
import '../provider/child_provider.dart';
import './service_exception.dart';

class ChildService {
  final ChildResource _childResource = ChildResource();
  static const String DEFAULT_MESSAGE = 'Não foi possivel ';

  Future<void> saveChild(final Child child) async {
    try {
      await _childResource.saveChild(child);
    } on ResourceException catch(err) {
      throw ServiceException(err.msg);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE salvar a criança', err);
    }
  }

  Future<void> setAllChildren(final ChildProvider childProvider) async {
    try {
      final children = await _childResource.getAllChildren();
      childProvider.emptyChildren();
      childProvider.addAll = children;
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE pegar todas as crianças', err);
    }
  }

  Future<void> updateStatusWaiting(final int itineraryId) async {
    try {
      await _childResource.updateStatusWaiting(itineraryId);
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE atualizar status da criança', err);
    }
  }

  Future<Child> updateChild(final Child child) async {
    try {
      return await _childResource.updateChild(child);
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE atualizar a criança', err);
    }
  }
}
