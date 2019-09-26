import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/token.dart';
import '../routes.dart';

class AuthService {
  static const String TOKEN_KEY = 'TOKEN';

  Future<void> login(final String token, final BuildContext context) async {
    try {
      final tokenConverted = Token.fromJSON(token);
      final tokenMap = Token.toJSON(tokenConverted);
      final preferences = await SharedPreferences.getInstance();
      preferences.setString(TOKEN_KEY, tokenMap);
      Navigator.pushReplacementNamed(context, Routes.HOME_PAGE);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
    }
  }

  void logout() {

  }
}
