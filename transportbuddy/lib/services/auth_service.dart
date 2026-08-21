import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles the "is this user logged in?" session state.
///
/// Flow:
/// 1. On successful sign-in (or OTP verification), call
///    `AuthService.saveSession()` — this generates a random token and
///    stores it on-device.
/// 2. On every app launch, `AuthService.isLoggedIn()` checks whether a
///    token is still stored. If yes, skip the login screens entirely and
///    go straight to HomeScreen (see main.dart).
/// 3. When the user taps Logout, call `AuthService.logout()` to clear the
///    token, sending them back to the login flow next launch.
class AuthService {
  static const _tokenKey = 'auth_token';

  /// Generates a random, URL-safe session token (32 bytes -> ~43 chars).
  /// Uses Random.secure() so it's cryptographically random, not just a
  /// predictable counter/timestamp.
  static String generateToken({int length = 32}) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// Call this right after a successful sign-in / OTP verification.
  /// Returns the generated token in case you want to attach it to
  /// subsequent API calls (e.g. as a Bearer token / header).
  static Future<String> saveSession() async {
    final token = generateToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    return token;
  }

  /// Reads the currently stored token, or null if none exists.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// True if a session token exists, meaning the user hasn't logged out.
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clears the stored session. Call this from your Logout button.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}