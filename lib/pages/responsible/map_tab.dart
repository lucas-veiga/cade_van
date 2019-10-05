import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/child_provider.dart';
import '../../widgets/child_item.dart';
import '../../widgets/custom_divider.dart';
import '../../utils/default_padding.dart';

class MapTab extends StatelessWidget {
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
            child: Consumer<ChildProvider>(
              builder: (_, final ChildProvider provider, __) =>
                ListView.separated(
                  itemCount: provider.children.length,
                  separatorBuilder: (BuildContext ctx, int i) => CustomDivider(),
                  itemBuilder: (BuildContext ctx, int i) => ChildItem(provider.children[i], i, false),
                ),
            ),
          ),
        ),
      ],
    );
  }
}
