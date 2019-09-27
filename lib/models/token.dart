import 'dart:convert';

class Token {
  Header header;
  Payload payload;
  String jwtEncoded;

  Token(final String sharedPreferencesToken) {
    final decoded = json.decode(sharedPreferencesToken);
    header = Header.fromJSON(decoded['header']);
    payload = Payload(decoded['payload']);
    jwtEncoded = decoded['jwtEncoded'];
  }

  Token.fromJSON(String token) {
    if (token.contains('Bearer')) {
      token = token.split('Bearer')[1].replaceAll(' ', '');
    }
    final List<String> parts = token.split('.');

    this.jwtEncoded = token;
    this.header = Header.fromJSON(json.decode(_decodeBase64(parts[0])));
    this.payload = Payload.fromJSON(json.decode(_decodeBase64(parts[1])));
  }

  static String toJSON(final Token token) {
    final Map<String, dynamic> map = {
      'jwtEncoded': token.jwtEncoded,
      'header': Header.toJSON(token.header),
      'payload': Payload.toJSON(token.payload),
    };
    return json.encode(map);
  }

  String _decodeBase64(String text) {
    switch (text.length % 4) {
      case 0:
        break;
      case 2:
        text += '==';
        break;
      case 3:
        text += '=';
        break;
      default:
        throw Exception('Invalid Base64');
    }
    return utf8.decode(Base64Codec().decode(text));
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Token: { ');
    buffer.write('jwtEncoded: $jwtEncoded, ');
    buffer.write('header: $header, ');
    buffer.write('payload: $payload');
    buffer.write(' }');
    return buffer.toString();
  }
}

class Header {
  final String alg;

  Header(this.alg);

  Header.fromJSON(dynamic json):
      alg = json['alg'].toString();

  static Map<String, dynamic> toJSON(final Header header) =>
    {
      'alg': header.alg,
    };

  @override
  String toString() {
    return 'Header: { alg: "$alg" }';
  }
}

class Payload {
  final String sub;
  final DateTime exp;

  Payload(final dynamic sharedPreferencesToken):
      this.sub = sharedPreferencesToken['sub'],
      this.exp = DateTime.parse(sharedPreferencesToken['exp']);

  Payload.fromJSON(dynamic json):
      sub = json['sub'],
      exp = DateTime.fromMillisecondsSinceEpoch(json['exp'] * 1000);

  static Map<String, dynamic> toJSON(final Payload payload) =>
    {
      'sub': payload.sub,
      'exp': payload.exp.toString(),
    };

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('Payload: { ');
    buffer.write('sub: "$sub", ');
    buffer.write('exp: "$exp"');
    buffer.write(" }");
    return buffer.toString();
  }
}
