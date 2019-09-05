import 'package:flutter/material.dart';

import '../widgets/child_item.dart';
import '../widgets/custom_divider.dart';
import '../utils/default_padding.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          top: 70,
          right: 0,
          left: 20,
          child: Text('Criancas fora de casa'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100, left: DefaultPadding.horizontal),
          child: Container(
            width: 170,
            height: 200,
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (BuildContext ctx, int i) => CustomDivider(),
              itemBuilder: (BuildContext ctx, int i) => ChildItem(i, false),
            ),
          ),
        ),
      ],
    );
  }
}
