part of instagram;

class Me extends EndpointPaging {
  @override
  String get _path => 'me';

  Me(InstagramApiBase api) : super(api);

  Future<User> get() async {
    final InstagramApiCredentials credentials = await _api.getCredentials();
    var jsonString = await _api._get('$_path?' + _buildQuery({'access_token': credentials.accessToken, 'fields': 'username,id,account_type,media_count'}));
    var map = json.decode(jsonString);
    return User.fromJson(map);
  }

  Future<Media> getMedia(String id) async {
    final InstagramApiCredentials credentials = await _api.getCredentials();
    var jsonString = await _api._get('$id?' + _buildQuery({'access_token': credentials.accessToken, 'fields': 'id,media_type,media_url,permalink,thumbnail_url,timestamp,username'}));
    var map = json.decode(jsonString);
    return Media.fromJson(map);
  }

  Future<Iterable<Media>> media() async {
    final InstagramApiCredentials credentials = await _api.getCredentials();
    var jsonString =
    await _api._get(
        '$_path/media?' + _buildQuery({'access_token': credentials.accessToken, 'fields': 'caption,id,media_type,media_url,permalink,thumbnail_url,timestamp,username,children', 'limit': 50}));
    var map = json.decode(jsonString);
    var items = map['data'] as Iterable<dynamic>;
    return items.map((item) => Media.fromJson(item));
  }
}
