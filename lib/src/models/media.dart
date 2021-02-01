part of instagram.models;

@JsonSerializable(createToJson: false)
class MediaContent extends Object {
  MediaContent();

  factory MediaContent.fromJson(Map<String, dynamic> json) => _$MediaContentFromJson(json);

  String caption;
  String id;
  String media_type;
  String media_url;
  String permalink;
  String thumbnail_url;
  String timestamp;
  String username;
}
