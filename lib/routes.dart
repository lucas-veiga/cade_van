import 'package:flutter/material.dart';

import './pages/export_pages.dart';

class Routes {
  static const String HOME_RESPONSIBLE_PAGE = '/home-page/responsible';
  static const String HOME_DRIVER_PAGE = '/home-page/driver';
  static const String CHILD_FORM = '/child-form';
  static const String AUTH_PAGE = '/auth-page';

  static final Map<String, WidgetBuilder> _availableRoutes = {
    HOME_RESPONSIBLE_PAGE: (BuildContext ctx) => MainResponsibleTab(),
    HOME_DRIVER_PAGE: (BuildContext ctx) => MainDriverTab(),
    CHILD_FORM: (BuildContext ctx) => ChildFormPage(),
    AUTH_PAGE: (BuildContext ctx) => MainAuthPage(),
  };

  static Map<String, WidgetBuilder> get availableRoutes => Map.from(_availableRoutes);
}
