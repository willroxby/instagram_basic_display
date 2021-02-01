part of instagram;

class InstagramApi extends InstagramApiBase {
  InstagramApi(InstagramApiCredentials credentials, {Function(InstagramApiCredentials) onCredentialsRefreshed})
      : super(credentials, http.Client(), onCredentialsRefreshed);

  InstagramApi.fromClient(FutureOr<oauth2.Client> client)
      : super.fromClient(client);

  InstagramApi.fromAuthCodeGrant(
      oauth2.AuthorizationCodeGrant grant, String responseUri)
      : super.fromAuthCodeGrant(grant, responseUri);

  static oauth2.AuthorizationCodeGrant authorizationCodeGrant(
      InstagramApiCredentials credentials, {Function(InstagramApiCredentials) onCredentialsRefreshed}) {
    return InstagramApiBase.authorizationCodeGrant(credentials, http.Client(), onCredentialsRefreshed);
  }
}