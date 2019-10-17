import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/child_item.dart';
import '../../widgets/custom_divider.dart';

import '../../models/child.dart';
import '../../utils/default_padding.dart';
import '../../provider/child_provider.dart';
import '../../services/routes_service.dart';

class HomeResponsibleTab extends StatelessWidget {
  final RoutesService _routesService = RoutesService();

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
              onLongPress: () => _routesService.goToChildDetailPage(context, i),
              onTap: () => _navigateToMap(provider.children[i]),
              child: DefaultPadding(
                child: ChildItem(provider.children[i], i),
              ),
            ),
        ),
    );
  }

  void _navigateToMap(final Child child) => print('MAPA ->\t$child');
}
