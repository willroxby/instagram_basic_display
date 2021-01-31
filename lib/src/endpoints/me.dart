part of instagram;

class Me extends EndpointPaging {
  @override
  String get _path => 'me';

  Me(InstagramApiBase api) : super(api);

  Future<User> get() async {
    var jsonString = await _api._get(_path);
    var map = json.decode(jsonString);

    return User.fromJson(map);
  }
}