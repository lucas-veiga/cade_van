class ServiceException implements Exception {
  final String msg;
  final dynamic err;
  
  ServiceException(this.msg, [ this.err ]);

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('ServiceException: { ');
    buffer.write('customMessage: "$msg", ');
    buffer.write('error: "$err"');
    buffer.write(' }');
    return buffer.toString();
  }
}
