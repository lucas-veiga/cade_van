import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/child_item.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/toast.dart';

import '../../utils/default_padding.dart';

import '../../models/child.dart';
import '../../provider/child_provider.dart';
import '../../services/routes_service.dart';

class HomeResponsibleTab extends StatelessWidget {
  final RoutesService _routesService = RoutesService();

  final Toast _toast = Toast();

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
              onTap: () => _navigateToMap(context, provider.children[i]),
              child: DefaultPadding(
                child: ChildItem(provider.children[i], i),
              ),
            ),
        ),
    );
  }

  void _navigateToMap(final BuildContext context, final Child child) {
    if (child.status == ChildStatusEnum.LEFT_HOME) {
      _toast.show('A sua criança está em casa', context, backgroundColorCustom: DecodeChileStatusEnum.getColor(child.status));
      return;
    }

    if (child.status == ChildStatusEnum.LEFT_SCHOOL) {
      _toast.show('A sua criança está na escola', context, backgroundColorCustom: DecodeChileStatusEnum.getColor(child.status));
      return;
    }

    Navigator.pushNamed(context, RoutesService.MAP_RESPONSIBLE_PAGE);
  }
}
