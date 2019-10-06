class ResourceException implements Exception {
  final String msg;
  final dynamic err;

  ResourceException(this.msg,  [ this.err ]);

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('ResourceException: { ');
    buffer.write('customMessage: "$msg", ');
    buffer.write('error: "$err"');
    buffer.write(' }');
    return buffer.toString();
  }
}
