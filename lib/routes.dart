import 'package:flutter/material.dart';

import './pages/export_pages.dart';

class Routes {
  static const String HOME_PAGE = '/home-page';
  static const String CHILD_FORM = '/child-form';

  static final Map<String, WidgetBuilder> _availableRoutes = {
    HOME_PAGE: (BuildContext ctx) => MainTab(),
    CHILD_FORM: (BuildContext ctx) => ChildFormPage(),
  };

  static Map<String, WidgetBuilder> get availableRoutes => Map.from(_availableRoutes);
}
