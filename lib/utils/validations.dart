import 'package:meta/meta.dart';

import './cpf.dart';

abstract class Validations {
    static final RegExp _regexEmail =
        RegExp(r'^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$');

    /// Massagem de retorno padrão:
    /// Campo tem que no mínimo [minLength]
    static String isGreaterThan({
        @required String input,
        @required int minLength,
        String customMessage
    }) {
        final String returnMessage = _buildReturnMessage('Campo tem que no mínimo $minLength', customMessage);

        if (isFieldEmpty(input: input) != null) {
          return ('Preencha o campo');
        }

        if (input.length < minLength) return returnMessage;
        return null;
    }

    /// Message de retorno padrão:
    /// Preencha o campo
    static String isFieldEmpty({
        @required String input,
        String customMessage,
    }) {
        final String returnMessage = _buildReturnMessage('Preencha o campo', customMessage);

        if (_isStringEmpty(input)) return returnMessage;
        return null;
    }

    static String isTelefoneValid(final String input, [final String customMessage]) {
      final String returnMessage = _buildReturnMessage('Telefone invalido', customMessage);

      if (isFieldEmpty(input: input) != null) {
        return ('Preencha o campo');
      }

      if (isGreaterThan(input: input, minLength: 10) != null) {
        return returnMessage;
      }
      return null;
    }

    static String isEmailValid({
        @required String input,
        String customMessage,
    }) {
        final String returnMessage = _buildReturnMessage('E-Mail invalido', customMessage);

        if (isFieldEmpty(input: input) != null) {
          return ('Preencha o campo');
        }

        if (!_regexEmail.hasMatch(input)) return returnMessage;
        return null;
    }

    static String defaultValidator(String input, int minLength) {
        String empty = isFieldEmpty(input: input);
        String greater = isGreaterThan(input: input, minLength: minLength);

        if (empty != null) return empty;
        if (greater != null) return greater;
        return null;
    }

    static String isCPFValid(final String input, {final String customMessage}) {
        final String returnMessage = _buildReturnMessage('CPF invalido', customMessage);

        if (isFieldEmpty(input: input) != null) {
          return ('Preencha o campo');
        }

        if (!CPFUtils.validarCPF(input)) return returnMessage;
        return null;
    }

    static bool _isStringEmpty(String input) {
        if (input == null) return true;
        if (input.isEmpty) return true;
        return false;
    }

    static String _buildReturnMessage(String defaultMsg, String customMessage) {
        if (_isStringEmpty(customMessage)) return defaultMsg;
        return customMessage;
    }
}

