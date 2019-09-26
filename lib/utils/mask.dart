import 'package:flutter_masked_text/flutter_masked_text.dart';

class CustomMask {
  MaskedTextController telefone() {
    return MaskedTextController(mask: '(00) 00000-0000');
  }

  String removeTelefoneMask(final String input) {
    return input.replaceAll('(', '')
    .replaceAll(')', '')
    .replaceAll(' ', '')
    .replaceAll('-', '');
  }
}
