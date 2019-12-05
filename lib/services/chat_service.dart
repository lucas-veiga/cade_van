import 'package:catcher/core/catcher.dart';

import '../resource/chat_resource.dart';
import '../resource/resource_exception.dart';
import '../provider/chat_provider.dart';

import '../models/chat.dart';
import './service_exception.dart';

class ChatService {
  final ChatResource _chatResource = ChatResource();

  static const String DEFAULT_MESSAGE = 'Não foi possivel ';

  Future<void> findAllMessages(final int driverId, final int responsibleId, final ChatProvider chatProvider) async {
    try {
      final chat = await _chatResource.findAllMessages(driverId, responsibleId);
      chatProvider.chat = chat;
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE pegar a lista de converca', err);
    }
  }

  Future<List<int>> findAllChatIds() async {
   try {
     return await _chatResource.findAllChatIds();
   } on ResourceException catch(err) {
     throw ServiceException(err.msg, err);
   } catch (err, stack) {
     Catcher.reportCheckedError(err, stack);
     throw ServiceException('$DEFAULT_MESSAGE pegar a lista de chats', err);
   }
  }
}
