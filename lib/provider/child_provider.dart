import 'package:flutter/material.dart';

import '../models/child.dart';

class ChildProvider with ChangeNotifier {
  List<Child> _children = [];

  List<Child> get children => List.unmodifiable(_children);

  set add(final Child child) {
    _children.add(child);
    notifyListeners();
  }

  set addAll(final List<Child> children) {
    _children.addAll(children);
    notifyListeners();
  }

  void emptyChildren() => _children.clear();

  void logout() {
    _children.clear();
    notifyListeners();
  }
}
