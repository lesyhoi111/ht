import 'package:shared_preferences/shared_preferences.dart';

class Store {
  const Store._();
  static const String _tokenKey = "TOKEN";
  static const String _refreshTokenKey = "REFRESHTOKEN";

  static Future<void> setToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, token);
  }

  static Future<void> setrRefreshToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_refreshTokenKey, token);
  }

  static Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_tokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_refreshTokenKey);
  }

  static Future<void> clearToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static Future<void> clearRefreshToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}

// await Store.setToken(token);