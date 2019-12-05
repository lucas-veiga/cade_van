import 'package:flutter/material.dart';

import '../models/chat.dart';

class ChatProvider with ChangeNotifier {
  Chat _chat = Chat();

  Chat get chat => Chat.copy(_chat);

  set chat(final Chat chat) {
    _chat = chat;
    notifyListeners();
  }

  set addMessage(final ChatMessage chatMessage) {
    _chat.chatMessages.add(chatMessage);
    notifyListeners();
  }
}
