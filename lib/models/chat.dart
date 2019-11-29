class Chat {
  int id;
  int driverId;
  int responsibleId;
  List<ChatMessage> chatMessages;

  Chat.fromJSON(final dynamic json):
      id = json['id'],
      driverId = json['driverId'],
      responsibleId = json['responsibleId'],
      chatMessages = _chatMessagesFromJSON(json['messages']);

  static Map<String, dynamic> toJSON(final Chat chat) =>
    {
      'id': chat.id,
      'driverId': chat.driverId,
      'responsibleId': chat.responsibleId,
      'messages': chat.chatMessages
      .map((item) => ChatMessage.toJSON(item)),
    };

  static List<ChatMessage> _chatMessagesFromJSON(final dynamic json) {
    if (json == null) {
      return List<ChatMessage>();
    }

    final list = json.map((item) => ChatMessage.fromJSON(item)).toList();
    return List<ChatMessage>.from(list);
  }

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer();
    buffer.write('Chat: ');
    buffer.write('{ ');
    buffer.write('id: $id, ');
    buffer.write('responsibleId: $responsibleId, ');
    buffer.write('driverId: $driverId, ');
    buffer.write('chatMessages: [ ');
    chatMessages.forEach((item) => buffer.write('${item.toString()}, '));
    buffer.write(' ]}');
    return buffer.toString();
  }
}

class ChatMessage {
  int id;
  int userId;
  int chatId;
  String text;
  DateTime createdAt;

  ChatMessage();

  ChatMessage.copy(final ChatMessage chatMessage):
    id = chatMessage.id,
    userId = chatMessage.userId,
    chatId = chatMessage.chatId,
    text = chatMessage.text,
    createdAt = chatMessage.createdAt;

  ChatMessage.fromJSON(final dynamic json):
      id = json['id'],
      userId = json['userId'],
      chatId = json['chatId'],
      text = json['text'],
      createdAt = DateTime.parse(json['createdAt']);

  static Map<String, dynamic> toJSON(final ChatMessage chatMessage) =>
    {
      'id': chatMessage.id,
      'userId': chatMessage.userId,
      'chatId': chatMessage.chatId,
      'text': chatMessage.text,
      'createdAt': chatMessage?.createdAt?.toIso8601String(),
    };

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer();
    buffer.write('ChatMessage: { ');
    buffer.write('id: $id, ');
    buffer.write('userId: $userId, ');
    buffer.write('chatId: $chatId, ');
    buffer.write('text: "$text", ');
    buffer.write('createdAt: "${createdAt?.toIso8601String()}", ');
    buffer.write(' }');
    return buffer.toString();
  }
}
