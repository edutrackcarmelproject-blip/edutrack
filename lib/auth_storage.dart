/*
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _tokenKey = 'jwt_token';
  static const String _roleKey = 'user_role';

  // SAVE TOKEN
  static Future<void> saveAuth(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);
  }

  // GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // GET ROLE
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // LOGOUT
  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
  }
}
*/
