class ServerException implements Exception {
  String message;
  ServerException([this.message = "An unexpected error occurred. Please try again later."] );
}

