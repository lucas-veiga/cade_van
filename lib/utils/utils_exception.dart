class UtilException implements Exception {
  final String msg;

  UtilException(this.msg);

  @override
  String toString() {
    return msg;
  }
}
