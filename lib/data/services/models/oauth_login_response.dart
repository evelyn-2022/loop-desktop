class OAuthLoginResponse {
  final String code;
  final String redirectUri;

  OAuthLoginResponse({
    required this.code,
    required this.redirectUri,
  });
}
