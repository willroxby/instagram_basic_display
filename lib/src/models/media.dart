part of instagram.models;

@JsonSerializable(createToJson: false)
class Media extends Object {
  Media();

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  String caption;
  String id;
  String media_type;
  String media_url;
  String permalink;
  String thumbnail_url;
  String timestamp;
  String username;
  Children children;
}
