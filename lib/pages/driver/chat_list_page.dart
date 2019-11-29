import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../services/chat_service.dart';
import '../../services/routes_service.dart';

import '../../widgets/custom_divider.dart';
import '../../utils/default_padding.dart';
import '../../provider/user_provider.dart';

class ChatListPage extends StatelessWidget {
  final ChatService _chatService      = ChatService();
  final RoutesService _routesService  = RoutesService();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, final UserProvider provider, __) =>
        ListView.separated(
          separatorBuilder: (_, __) => CustomDivider(height: 0),
          itemCount: provider.myResponsible.length,
          itemBuilder:
          (_, final int i) =>
            InkWell(
              onTap: () => _openChat(provider.user.responsibleId, provider.myResponsible[i].driverId, context),
              child: DefaultPadding(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: Text(
                        _getAvatarIcon(provider.myResponsible[i].name),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30
                        ),
                      ),
                      radius: 50,
                    ),
                    SizedBox(width: 10),
                    Text(
                      provider.myResponsible[i].name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
        ),
    );
  }

  Future _openChat(final int driverId, final int responsibleId, final BuildContext context) async {
    print('driver id -> $driverId | resId -> $responsibleId');
    final chat = await _chatService.findAllMessages(driverId, responsibleId);
    _routesService.goToChatPage(context, chat);
  }

  String _getAvatarIcon(final String text) {
    final title = text.split(' ');
    final StringBuffer builder = StringBuffer();
    
    if (title.length > 2) {
      final firstLetter = title.first.substring(0, 1);
      final lastLatter = title[1].substring(0, 1);
      builder.write(firstLetter + lastLatter);
      return builder.toString();
    }
    
    title.forEach((item) {
      builder.write(item.substring(0, 1));
    });
    return builder.toString();
  }
}
