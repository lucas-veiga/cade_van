import 'package:flutter_masked_text/flutter_masked_text.dart';

class CustomMask {
  MaskedTextController telefone() =>
    MaskedTextController(mask: '(00) 00000-0000');


  MaskedTextController cpf() =>
    MaskedTextController(mask: '000.000.000-00');

  String removeCPFMask(final String input) =>
    input
      .replaceAll('.', '')
      .replaceAll('-', '');

  String removeTelefoneMask(final String input) =>
    input
      .replaceAll('(', '')
      .replaceAll(')', '')
      .replaceAll(' ', '')
      .replaceAll('-', '');
}
