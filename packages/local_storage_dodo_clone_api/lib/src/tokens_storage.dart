import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _kTokenKey = 'main_token';
const _kRefreshTokenKey = 'refresh_token';

class TokensStorage {
  TokensStorage._();
  static final TokensStorage instance = TokensStorage._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<String?> get getToken async {
    return await _storage.read(key: _kTokenKey);
  }

  Future<String?> get getRefreshToken async {
    return await _storage.read(key: _kRefreshTokenKey);
  }

  Future<void> setToken(String token) async {
    _storage.write(key: _kTokenKey, value: token);
  }

  Future<void> clearStorage() async {
    _storage.deleteAll();
  }
}
