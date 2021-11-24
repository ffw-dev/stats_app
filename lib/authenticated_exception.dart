class SessionDoesntExistException implements Exception {
  final String message;

  SessionDoesntExistException(this.message);
}