import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../../models/chat.dart';
import '../../services/socket_chat_service.dart';
import '../../provider/user_provider.dart';

class ChatPage extends StatefulWidget {
  final Chat _chat;

  ChatPage(this._chat);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatMessage _chatMessage = ChatMessage();
  final TextEditingController _editingController = TextEditingController();
  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 70.0));

    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    print('CHAT -> ${widget._chat}');
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
                    itemCount: widget._chat.chatMessages.length,
                    itemBuilder: (ctx, i) {
                      if (widget._chat.chatMessages.isNotEmpty && widget._chat.chatMessages[i].userId != userProvider.user.userId) {
                        return ReceivedMessage(widget._chat.chatMessages[i]);
                      } else {
                        return SentMessage(widget._chat.chatMessages[i]);
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
                        onTap: () => _onSendingMsg(userProvider),
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

  Future _onSendingMsg(final UserProvider userProvider) async {
    if (_chatMessage.text == null) return;
    await SocketChatService.init();

    _chatMessage.chatId = widget._chat.id;
    _chatMessage.userId = userProvider.user.userId;
    _chatMessage.createdAt = DateTime.now();
    SocketChatService.sendMessage(widget._chat.id, _chatMessage);
    setState(() => widget._chat.chatMessages.add(ChatMessage.copy(_chatMessage)));
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
