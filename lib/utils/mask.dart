import 'package:flutter_masked_text/flutter_masked_text.dart';

class CustomMask {
  MaskedTextController telefone() =>
    MaskedTextController(mask: '(00) 00000-0000');


  MaskedTextController cpf() =>
    MaskedTextController(mask: '000.000.000-00');

  dynamic date([ final DateTime date ]) {
    if (date != null) {
      final day = date.day <= 9 ? '0${date.day}' : date.day;
      final month = date.month <= 9 ? '0${date.month}' : date.month;
      final year = date.year;
      return '$day/$month/$year';
    }
    return MaskedTextController(mask: '00/00/0000');
  }

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
