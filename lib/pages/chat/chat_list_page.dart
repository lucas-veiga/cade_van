import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../services/chat_service.dart';
import '../../services/routes_service.dart';

import '../../provider/user_provider.dart';
import '../../provider/chat_provider.dart';

import '../../widgets/custom_divider.dart';
import '../../utils/default_padding.dart';
import '../../models/user.dart';

class ChatListPage extends StatelessWidget {
  final ChatService _chatService      = ChatService();
  final RoutesService _routesService  = RoutesService();
  final UserTypeEnum userType;

  ChatListPage(this.userType);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, final UserProvider provider, __) =>
        ListView.separated(
          separatorBuilder: (_, __) => CustomDivider(height: 0),
          itemCount: userType == UserTypeEnum.DRIVER ? provider.myResponsible.length : provider.myDrivers.length,
          itemBuilder:
          (_, final int i) =>
            InkWell(
              onTap: () => _openChat(
                userType == UserTypeEnum.DRIVER ? provider.user.driverId : provider.myDrivers[i].driverId,
                userType == UserTypeEnum.DRIVER ? provider.myResponsible[i].responsibleId : provider.user.responsibleId,
                context),
              child: DefaultPadding(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: Text(
                        _getAvatarIcon(userType == UserTypeEnum.DRIVER ? provider.myResponsible[i].name : provider.myDrivers[i].name),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30
                        ),
                      ),
                      radius: 50,
                    ),
                    SizedBox(width: 10),
                    Text(
                      userType == UserTypeEnum.DRIVER ? provider.myResponsible[i].name : provider.myDrivers[i].name,
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
    final ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);

    await _chatService.findAllMessages(driverId, responsibleId, chatProvider);
    _routesService.goToChatPage(context);
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
