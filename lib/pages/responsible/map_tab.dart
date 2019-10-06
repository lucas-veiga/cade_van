import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../../provider/child_provider.dart';
import '../../provider/user_provider.dart';

import '../../models/user.dart';
import '../../widgets/child_item.dart';
import '../../widgets/custom_divider.dart';
import '../../utils/default_padding.dart';

class MapTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context, listen: false).user;

    print('USER ON MAP_TAB -> \n$user');

    return Stack(
      children: <Widget>[
        Container(color: Colors.deepPurple),
      ],
    );
  }
}
