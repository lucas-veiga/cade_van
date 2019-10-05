import 'package:flutter/material.dart';

import 'package:catcher/core/catcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/service_exception.dart';
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
      throw ServiceException('Error ao realizar login');
    }
  }

  Future<bool> canEnter() async {
      try {
        final preferences = await SharedPreferences.getInstance();
        final tokenStr = preferences.getString(Token.TOKEN_KEY);
        if (tokenStr == null) return false;
        final token = Token(tokenStr);
        return token.payload.exp.isAfter(DateTime.now());
      } catch (err, stack) {
        Catcher.reportCheckedError(err, stack);
        throw ServiceException('Error ao verificar o token');
      }
  }

  Future<void> logout(final BuildContext context) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final res = await preferences.remove(Token.TOKEN_KEY);
      if (res) {
        Navigator.pushReplacementNamed(context, Routes.AUTH_PAGE);
        return;
      }
      throw ServiceException('Não foi possível sair conta');
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('Error ao sair conta');
    }
  }
}
