class ResourceException implements Exception {
  final String msg;

  ResourceException(this.msg);

  @override
  String toString() {
    return msg;
  }
}
