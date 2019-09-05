import 'package:flutter/material.dart';

import '../models/child.dart';

class ChildItem extends StatelessWidget {
  final bool showAvatar;
  final int index;
  ChildItem(this.index, [this.showAvatar = true]);

  @override
  Row build(BuildContext context) {
    return Row(
      children: <Widget>[
        Hero(
          tag: 'child_avatar_$index',
          child: CircleAvatar(
            radius: 40,
          ),
        ),
        if (showAvatar) SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Marios Antonius'),
              Text(
                'Centro de Ensino Medio 01 de Sobradinho',
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
              Text(
                DecodeChileStatusEnum.getText(ChildStatusEnum.DEIXADO_ESCOLA),
                style: TextStyle(
                  color: DecodeChileStatusEnum.getColor(ChildStatusEnum.DEIXADO_ESCOLA),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
