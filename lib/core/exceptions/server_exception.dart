class ServerException implements Exception {
  String? message;

  ServerException({this.message});

  String toString() {
    Object? message = this.message;
    if (message == null) return "ServerException";
    return "ServerException: $message";
  }
}
