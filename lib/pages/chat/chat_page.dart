import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../../provider/chat_provider.dart';

import '../../widgets/widgets.dart';
import '../../models/chat.dart';
import '../../services/socket_chat_service.dart';

class ChatPage extends StatelessWidget {
  final ChatMessage _chatMessage = ChatMessage();
  final TextEditingController _editingController = TextEditingController();
  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    final height = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) =>
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent + height));

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(15),
                    itemCount: chatProvider.chat.chatMessages.length,
                    itemBuilder: (ctx, i) {
                      if (chatProvider.chat.chatMessages.isNotEmpty && chatProvider.chat.chatMessages[i].userId != userProvider.user.userId) {
                        return ReceivedMessage(chatProvider.chat.chatMessages[i]);
                      } else {
                        return SentMessage(chatProvider.chat.chatMessages[i]);
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  height: 60,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 5,
                                color: Colors.grey)
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _editingController,
                                  onChanged: (item) => _chatMessage.text = item,
                                  decoration: InputDecoration(
                                    hintText: "Digite sua mensagem",
                                    border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _onSendingMsg(userProvider, chatProvider),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                          child: InkWell(
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _onSendingMsg(final UserProvider userProvider, final ChatProvider chatProvider) async {
    if (_chatMessage.text == null) return;
    await SocketChatService.init();

    _chatMessage.chatId = chatProvider.chat.id;
    _chatMessage.userId = userProvider.user.userId;
    _chatMessage.createdAt = DateTime.now();
    SocketChatService.sendMessage(chatProvider.chat.id, _chatMessage);
    _chatMessage.text = null;
    _editingController.clear();
  }
}

List<IconData> icons = [
  Icons.image,
  Icons.camera,
  Icons.file_upload,
  Icons.folder,
  Icons.gif
];
