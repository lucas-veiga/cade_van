import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/child_item.dart';
import '../../widgets/custom_divider.dart';

import '../../models/child.dart';
import '../../utils/default_padding.dart';
import 'child_detail_page.dart';
import '../../provider/child_provider.dart';

class HomeResponsibleTab extends StatelessWidget {
  @override
  Consumer build(BuildContext context) {
    return Consumer<ChildProvider>(
      builder: (_, final ChildProvider provider, __) =>
        ListView.separated(
          separatorBuilder: (BuildContext ctx, int i) => CustomDivider(height: 0),
          itemCount: provider.children.length,
          itemBuilder:
            (_, int i) =>
            InkWell(
              onLongPress: () => _navigateToChildDetail(context, i, provider.children[i]),
              onTap: () => _navigateToMap(provider.children[i]),
              child: DefaultPadding(
                child: ChildItem(provider.children[i], i),
              ),
            ),
        ),
    );
  }

  void _navigateToChildDetail(final BuildContext context, final int i, final Child child) =>
    Navigator.push(context, PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) => ChildDetailPage(i),
    ));

  void _navigateToMap(final Child child) => print('MAPA ->\t$child');
}
