import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/token.dart';
import '../routes.dart';

class AuthService {
  Future<void> login(final String token, final BuildContext context) async {
    try {
      final tokenConverted = Token.fromJSON(token);
      final tokenMap = Token.toJSON(tokenConverted);
      final preferences = await SharedPreferences.getInstance();
      preferences.setString(Token.TOKEN_KEY, tokenMap);
      Navigator.pushReplacementNamed(context, Routes.HOME_PAGE);
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
    }
  }

  Future<bool> canEnter() async {
//    return false;
      final preferences = await SharedPreferences.getInstance();
//      final tokenStr = preferences.remove(Token.TOKEN_KEY);
      final tokenStr = preferences.getString(Token.TOKEN_KEY);
      if (tokenStr == null) return false;
      final token = Token(tokenStr);
      return token.payload.exp.isAfter(DateTime.now());
  }

  void logout() {

  }
}
