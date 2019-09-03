import 'package:flutter/material.dart';

import './pages/export_pages.dart';

class Routes {
  static const String HOME_PAGE = './home-page';

  static final Map<String, WidgetBuilder> _availableRoutes = {
    HOME_PAGE: (BuildContext ctx) => MainTab(),
  };

  static Map<String, WidgetBuilder> get availableRoutes => Map.from(_availableRoutes);
}