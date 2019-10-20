import 'package:flutter/material.dart';

import '../utils/application_color.dart';

class DefaultAlertDialog extends StatelessWidget {
  final String stringTitle;
  final ApplicationColorEnum stringTitleColor;
  final Widget widgetTitle;
  final String stringContent;
  final Widget widgetContent;
  final List<Widget> actions;
  final BuildContext context;

  DefaultAlertDialog(this.context, {
    this.stringTitle,
    this.stringTitleColor,
    this.widgetTitle,
    this.stringContent,
    this.widgetContent,
    this.actions,
  });

  @override
  AlertDialog build(BuildContext context) =>
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: _title,
      content: _content,
      actions: _actions,
    );

  Widget get _title {
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

  Widget get _content {
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

  List<Widget> get _actions {
    if (actions == null) {
      return <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'OK',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ];
    }
    return actions;
  }
}
