import 'package:shared_preferences/shared_preferences.dart';

import '../models/token.dart';

class TokenUtil {
  Future<Token> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    final tokenStr = preferences.getString(Token.TOKEN_KEY);
    if (tokenStr == null) {
      return null;
    }
    return Token(tokenStr);
  }
}
