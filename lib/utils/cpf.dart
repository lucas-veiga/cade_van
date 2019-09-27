class CPFUtils {
  static bool validarCPF(String cpf){
    if (cpf.length < 11) return false;

    List<int> sanitizedCPF = cpf
      .split('')
      .map((String digit) => int.parse(digit))
      .toList();
    return !_blacklistedCPF(sanitizedCPF.join()) &&
      sanitizedCPF[9] == _gerarDigitoVerificador(sanitizedCPF.getRange(0, 9).toList()) &&
      sanitizedCPF[10] == _gerarDigitoVerificador(sanitizedCPF.getRange(0, 10).toList());
  }

  static int _gerarDigitoVerificador(List<int> digits) {
    int baseNumber = 0;
    for (var i = 0; i < digits.length; i++) {
      baseNumber += digits[i] * ((digits.length + 1) - i);
    }
    int verificationDigit = baseNumber * 10 % 11;
    return verificationDigit >= 10 ? 0 : verificationDigit;
  }

  static bool _blacklistedCPF(String cpf) {
    return
      cpf == '11111111111' ||
        cpf == '22222222222' ||
        cpf == '33333333333' ||
        cpf == '44444444444' ||
        cpf == '55555555555' ||
        cpf == '66666666666' ||
        cpf == '77777777777' ||
        cpf == '88888888888' ||
        cpf == '99999999999';
  }
}
