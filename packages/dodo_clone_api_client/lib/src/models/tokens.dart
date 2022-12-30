/*
{
    "access_token": "ca4c6e630058d46e0052232e00000e6b0000030e129d22b62ba335bc3867e8f18b9816",
    "expires": 1668173002,
    "expires_in": 3600,
    "scope": "app",
    "domain": "keuneshop.6hi.ru",
    "server_endpoint": "https://oauth.bitrix.info/rest/",
    "status": "L",
    "client_endpoint": "http://keuneshop.6hi.ru/rest/",
    "member_id": "9c69be6f883daf9af8e859f43eb0f4f8",
    "user_id": 3691,
    "refresh_token": "bacb95630058d46e0052232e00000e6b000003259c87226e74519c3df7162f3a0b83fe"
}
 */

Tokens tokensFromJson(Map<String, dynamic> json) => Tokens.fromJson(json);

class Tokens {
  final String accessToken;
  final int expires;
  final int expiresIn;
  final String scope;
  final String domain;
  final String serverEndpoint;
  final String status;
  final String clientEndpoint;
  final String memberId;
  final int userId;
  final String refreshToken;

  const Tokens({
    required this.accessToken,
    required this.expires,
    required this.expiresIn,
    required this.scope,
    required this.domain,
    required this.serverEndpoint,
    required this.status,
    required this.clientEndpoint,
    required this.memberId,
    required this.userId,
    required this.refreshToken,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
        accessToken: json['access_token'],
        expires: json['expires'],
        expiresIn: json['expires_in'],
        scope: json['app'],
        domain: json['domain'],
        serverEndpoint: json['server_endpoint'],
        status: json['status'],
        clientEndpoint: json['client_endpoint'],
        memberId: json['member_id'],
        userId: json['user_id'],
        refreshToken: json['refresh_token'],
      );
}
