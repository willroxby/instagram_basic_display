
part of instagram;

abstract class InstagramApiBase {
  static const String _baseUrl = 'https://graph.instagram.com';
  static const String _tokenUrl = 'https://api.instagram.com/oauth/access_token';
  static const String _authorizationUrl = 'https://api.instagram.com/oauth/authorize';

  bool _shouldWait = false;
  FutureOr<oauth2.Client> _client;
  Me _me;
  Me get me => _me;
  Media _media;
  Media get media => _media;
  oauth2.Client get client => _client;

  InstagramApiBase.fromClient(FutureOr<http.BaseClient> client) {
    _client = client;

    _me = Me(this);
    _media = Media(this);
  }

  InstagramApiBase(InstagramApiCredentials credentials, [http.BaseClient httpClient, Function(InstagramApiCredentials) callBack])
      : this.fromClient(_getOauth2Client(credentials, httpClient, callBack));

  InstagramApiBase.fromAuthCodeGrant(oauth2.AuthorizationCodeGrant grant, String responseUri)
      : this.fromClient(grant.handleAuthorizationResponse(Uri.parse(responseUri).queryParameters));

  static oauth2.AuthorizationCodeGrant authorizationCodeGrant(InstagramApiCredentials credentials, http.BaseClient httpClient,
      [Function(InstagramApiCredentials) callBack]) {
    if (callBack == null)
      return oauth2.AuthorizationCodeGrant(credentials.clientId, Uri.parse(InstagramApiBase._authorizationUrl), Uri.parse(InstagramApiBase._tokenUrl),
          secret: credentials.clientSecret, httpClient: httpClient);

    return oauth2.AuthorizationCodeGrant(credentials.clientId, Uri.parse(InstagramApiBase._authorizationUrl), Uri.parse(InstagramApiBase._tokenUrl),
        secret: credentials.clientSecret, httpClient: httpClient, onCredentialsRefreshed: (oauth2.Credentials cred) {
          InstagramApiCredentials newCredentials = InstagramApiCredentials(credentials.clientId, credentials.clientSecret,
              accessToken: cred.accessToken, expiration: cred.expiration, refreshToken: cred.refreshToken, scopes: cred.scopes);
          callBack(newCredentials);
        });
  }

  static FutureOr<oauth2.Client> _getOauth2Client(InstagramApiCredentials credentials, http.BaseClient httpClient,
      [Function(InstagramApiCredentials) callBack]) async {
    if (credentials.fullyQualified) {
      var oauthCredentials = credentials._toOauth2Credentials();

      if (oauthCredentials.isExpired) {
        oauthCredentials = await oauthCredentials.refresh(
          identifier: credentials.clientId,
          secret: credentials.clientSecret,
          httpClient: httpClient,
        );
      }

      return oauth2.Client(
        oauthCredentials,
        identifier: credentials.clientId,
        onCredentialsRefreshed: callBack == null
            ? null
            : (oauth2.Credentials cred) {
          InstagramApiCredentials newCredentials = InstagramApiCredentials(credentials.clientId, credentials.clientSecret,
              accessToken: cred.accessToken, expiration: cred.expiration, refreshToken: cred.refreshToken, scopes: cred.scopes);
          callBack(newCredentials);
        },
        secret: credentials.clientSecret,
      );

    }

    return oauth2.clientCredentialsGrant(
      Uri.parse(InstagramApiBase._tokenUrl),
      credentials.clientId,
      credentials.clientSecret,
      httpClient: httpClient,
    );
  }

  Future<String> _get(String path) {
    return _getImpl('${_baseUrl}/$path', const {});
  }

  Future<String> _post(String path, [String body = '']) {
    return _postImpl('${_baseUrl}/$path', const {}, body);
  }

  Future<String> _delete(String path, [String body = '']) {
    return _deleteImpl('${_baseUrl}/$path', const {}, body);
  }

  Future<String> _put(String path, [String body = '']) {
    return _putImpl('${_baseUrl}/$path', const {}, body);
  }

  Future<String> _getImpl(String url, Map<String, String> headers) async {
    return await _requestWrapper(
            () async => await (await _client).get(url, headers: headers));
  }

  Future<String> _postImpl(
      String url, Map<String, String> headers, dynamic body) async {
    return await _requestWrapper(() async =>
    await (await _client).post(url, headers: headers, body: body));
  }

  Future<String> _deleteImpl(
      String url, Map<String, String> headers, body) async {
    return await _requestWrapper(() async {
      final request = http.Request('DELETE', Uri.parse(url));
      request.headers.addAll(headers);
      request.body = body;
      return await http.Response.fromStream(
          await (await _client).send(request));
    });
  }

  Future<String> _putImpl(
      String url, Map<String, String> headers, dynamic body) async {
    return await _requestWrapper(() async =>
    await (await _client).put(url, headers: headers, body: body));
  }

  Future<String> _requestWrapper(Future<http.Response> Function() request,
      {retryLimit = 5}) async {
    for (var i = 0; i < retryLimit; i++) {
      while (_shouldWait) {
        await Future.delayed(Duration(milliseconds: 500));
      }
      try {
        return handleErrors(await request());
      } on ApiRateException catch (ex) {
        if (i == retryLimit - 1) rethrow;
        print(
            'Instagram API rate exceeded. waiting for ${ex.retryAfter} seconds');
        _shouldWait = true;
        unawaited(Future.delayed(Duration(seconds: ex.retryAfter))
            .then((v) => _shouldWait = false));
      }
    }
    throw InstagramException('Could not complete request');
  }

  Future<InstagramApiCredentials> getCredentials() async {
    return await InstagramApiCredentials._fromClient(await _client);
  }

  String handleErrors(http.Response response) {
    final responseBody = utf8.decode(response.bodyBytes);
    if (response.statusCode >= 400) {
      final jsonMap = json.decode(responseBody);
      final error = InstagramError.fromJson(jsonMap['error']);
      if (response.statusCode == 429) {
        throw ApiRateException.fromInstagram(
            error, num.parse(response.headers['retry-after']));
      }
      throw InstagramException.fromInstagram(
        error,
      );
    }
    return responseBody;
  }
}