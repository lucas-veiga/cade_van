class ServiceException implements Exception {
  final String msg;

  ServiceException(this.msg);

  @override
  String toString() {
    return this.msg;
  }
}
