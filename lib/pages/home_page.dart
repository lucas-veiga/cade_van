import 'package:flutter/material.dart';

import '../widgets/child_item.dart';
import '../widgets/custom_divider.dart';
import '../utils/default_padding.dart';

class HomePage extends StatelessWidget {
  @override
  ListView build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext ctx, int i) => CustomDivider(),
      itemCount: 10,
      itemBuilder:
          (BuildContext ctx, int i) =>
            DefaultPadding(
              child: ChildItem(),
            ),
    );
  }
}
