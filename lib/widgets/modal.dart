import 'package:flutter/material.dart';

import '../utils/application_color.dart';

class Modal {
  Future<bool> showModal(
    final BuildContext context,
    {
      final String stringTitle,
      final ApplicationColorEnum stringTitleColor,
      final Widget widgetTitle,
      final String stringContent,
      final Widget widgetContent,
      final List<Widget> actions,
    }) async {
    final answer = await showDialog(
      context: context,
      builder: (final BuildContext ctx) =>
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: _getTitle(stringTitle, widgetTitle, stringTitleColor),
          content: _getContent(stringContent, widgetContent),
          actions: _getActions(actions, ctx),
        )
    );

    return answer == null ? false : true;
  }

  Widget _getTitle(final String stringTitle, final Widget widgetTitle, final ApplicationColorEnum stringTitleColor) {
    if (stringTitle == null && widgetTitle != null) {
      return widgetTitle;
    }

    if (widgetTitle == null && stringTitle != null) {
      return Text(
        stringTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: stringTitleColor == null ? ApplicationColor.decodeEnum(ApplicationColorEnum.MAIN) : ApplicationColor.decodeEnum(stringTitleColor),
        ),
      );
    }

    return Text(
      'Modal',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: stringTitleColor == null ? Colors.black : ApplicationColor.decodeEnum(stringTitleColor),
      )
    );
  }

  Widget _getContent(final String stringContent, final Widget widgetContent) {
    if (stringContent == null && widgetContent != null) {
      return widgetContent;
    }

    if (widgetContent == null && stringContent != null) {
      return Text(
        stringContent,
        textAlign: TextAlign.start,
      );
    }

    return Text(
      'Conteudo da Modal',
      textAlign: TextAlign.start,
    );
  }

  List<Widget> _getActions(final List<Widget> actions, final BuildContext ctx) {
    if (actions == null) {
      return <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(
            'OK',
            style: TextStyle(
              color: Theme.of(ctx).primaryColor,
            ),
          ),
        )
      ];
    }
    return actions;
  }
}
