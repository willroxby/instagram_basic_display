// GENERATED CODE - DO NOT MODIFY BY HAND

part of instagram.models;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstagramError _$InstagramErrorFromJson(Map<String, dynamic> json) {
  return InstagramError()
    ..status = json['status'] as int
    ..message = json['message'] as String;
}

MediaContent _$MediaContentFromJson(Map<String, dynamic> json) {
  return MediaContent()
    ..caption = json['caption'] as String
    ..id = json['id'] as String
    ..media_type = json['media_type'] as String
    ..media_url = json['media_url'] as String
    ..permalink = json['permalink'] as String
    ..thumbnail_url = json['thumbnail_url'] as String
    ..timestamp = json['timestamp'] as String
    ..username = json['username'] as String;
}

Paging<T> _$PagingFromJson<T>(Map<String, dynamic> json) {
  return Paging<T>()
    ..href = json['href'] as String
    ..itemsNative = itemsNativeFromJson(json['items'] as List)
    ..limit = json['limit'] as int
    ..next = json['next'] as String
    ..offset = json['offset'] as int
    ..previous = json['previous'] as String
    ..total = json['total'] as int;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..account_type = json['account_type'] as String
    ..id = json['id'] as String
    ..media_count = json['media_count'] as String
    ..username = json['username'] as String;
}
