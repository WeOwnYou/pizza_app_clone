AuthData authDataFromJson(Map <String, dynamic> json) => AuthData.fromJson(json);

/*
{
    "status": "ok",
    "info": "Код выслан в СМС на указанный номер",
    "expire": 60
}
 */

class AuthData {
  final String status;
  final String info;
  final int expire;

  const AuthData({
    required this.status,
    required this.info,
    required this.expire,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
      status: json['status'],
      info: json['info'],
      expire: json['expire'],
  );
}