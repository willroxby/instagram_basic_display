part of instagram.models;

@JsonSerializable(createToJson: false)
class InstagramError extends Object {
  InstagramError();

  factory InstagramError.fromJson(Map<String, dynamic> json) =>
      _$InstagramErrorFromJson(json);

  /// The HTTP status code (also returned in the response header; see Response
  /// Status Codes for more information).
  int? status;

  /// A short description of the cause of the error.
  String? message;
}
