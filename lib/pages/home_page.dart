import 'package:flutter/material.dart';

import '../widgets/child_item.dart';
import '../widgets/custom_divider.dart';
import '../utils/default_padding.dart';
import './child_detail_page.dart';

class HomePage extends StatelessWidget {
  @override
  ListView build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext ctx, int i) => CustomDivider(),
      itemCount: 10,
      itemBuilder:
          (BuildContext ctx, int i) =>
            InkWell(
              onTap: () => Navigator.push(context, PageRouteBuilder(
//                transitionDuration: Duration(milliseconds: 10000),
                transitionDuration: Duration(milliseconds: 700),
                pageBuilder: (BuildContext ctx, _, __) => ChildDetailPage(i),
              )),
              child: DefaultPadding(
                child: ChildItem(i),
              ),
            ),
    );
  }
}
