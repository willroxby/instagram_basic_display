part of instagram;

class InstagramException implements Exception {
  int status;
  String message;

  InstagramException([this.message]);

  InstagramException.fromInstagram(InstagramError error) {
    status = error.status;
    message = error.message;
  }

  @override
  String toString() => 'Error Code: $status\r\n$message';
}

class ApiRateException extends InstagramException {
  final num retryAfter;

  ApiRateException.fromInstagram(InstagramError error, this.retryAfter)
      : super.fromInstagram(error);
}
