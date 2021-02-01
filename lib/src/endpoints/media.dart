part of instagram;

class Media extends EndpointPaging {
  @override
  String get _path => '';

  Media(InstagramApiBase api) : super(api);

  Pages<MediaContent> media(String userId) {
    return _getPages('$userId', (json) => MediaContent.fromJson(json));
  }
}
