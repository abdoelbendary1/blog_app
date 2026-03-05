class Failures {
  final String? message;
  Failures([
    this.message = "An unexpected error occurred. Please try again later.",
  ]);
}

class ServerFailure extends Failures {
  ServerFailure([String? message]) : super(message);
}
