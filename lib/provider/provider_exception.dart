class ProviderException implements Exception {
  final String msg;
  final dynamic err;

  ProviderException(this.msg, [ this.err ]);

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('ProviderException: { ');
    buffer.write('customMessage: "$msg", ');
    buffer.write('error: "$err"');
    buffer.write(' }');
    return buffer.toString();
  }
}
