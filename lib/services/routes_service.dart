import 'package:cade_van/models/itinerary.dart';
import 'package:flutter/material.dart';

import '../models/child.dart';
import '../pages/export_pages.dart';

class RoutesService {
  static const String HOME_RESPONSIBLE_PAGE = '/home-page/responsible';
  static const String MAP_RESPONSIBLE_PAGE = '/map-page/responsible';
  static const String HOME_DRIVER_PAGE = '/home-page/driver';
  static const String CHILD_FORM = '/child-form';
  static const String ITINERARY_FORM_PAGE = '/itinerary-form';
  static const String AUTH_PAGE = '/auth-page';

  static final Map<String, WidgetBuilder> _availableRoutes = {
    HOME_RESPONSIBLE_PAGE: (final BuildContext ctx) => MainResponsibleTab(),
    MAP_RESPONSIBLE_PAGE: (final BuildContext ctx) => MapResponsibleTab(),
    HOME_DRIVER_PAGE: (final BuildContext ctx) => MainDriverTab(),
    CHILD_FORM: (final BuildContext ctx) => ChildFormPage(),
    AUTH_PAGE: (final BuildContext ctx) => MainAuthPage(),
  };

  static Map<String, WidgetBuilder> get availableRoutes => Map.from(_availableRoutes);

  Future<dynamic> goToItineraryFormPage(final BuildContext context, final List<Child> children) async {
    return await Navigator.push(context, MaterialPageRoute(
      builder: (_) => ItineraryFormPage(children),
    ));
  }

  Future<dynamic> goToItineraryDetail(final BuildContext context, final Itinerary itinerary) async {
    return await Navigator.push(context, MaterialPageRoute(
      builder: (_) => ItineraryDetailPage(itinerary),
    ));
  }

  Future<dynamic> goToChildDetailPage(final BuildContext context, final int index) async {
    Navigator.push(context, PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) => ChildDetailPage(index),
    ));
  }
}
