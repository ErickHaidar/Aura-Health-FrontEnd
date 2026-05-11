import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  // Keys untuk SharedPreferences
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';

  // ─── Login ───
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: ApiConfig.headers(null),
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final tokenData = data['data'];
        if (tokenData != null) {
          if (tokenData['accessToken'] != null) {
            await prefs.setString(_keyAccessToken, tokenData['accessToken']);
          }
          if (tokenData['refreshToken'] != null) {
            await prefs.setString(_keyRefreshToken, tokenData['refreshToken']);
          }
          // Simpan info user jika ada
          if (tokenData['user'] != null) {
            final user = tokenData['user'];
            if (user['name'] != null) await prefs.setString(_keyUserName, user['name']);
            if (user['email'] != null) await prefs.setString(_keyUserEmail, user['email']);
          }
        }
        return {'success': true, 'message': data['message'] ?? 'Login berhasil'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Register ───
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: ApiConfig.headers(null),
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': data['message'] ?? 'Registrasi berhasil'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Register gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Request OTP ───
  static Future<Map<String, dynamic>> requestOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/otp/request'),
        headers: ApiConfig.headers(null),
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'OTP terkirim'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal mengirim OTP'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Verify OTP ───
  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/otp/verify'),
        headers: ApiConfig.headers(null),
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Jika verify OTP juga mengembalikan token (auto-login)
        final tokenData = data['data'];
        if (tokenData != null) {
          final prefs = await SharedPreferences.getInstance();
          if (tokenData['accessToken'] != null) {
            await prefs.setString(_keyAccessToken, tokenData['accessToken']);
          }
          if (tokenData['refreshToken'] != null) {
            await prefs.setString(_keyRefreshToken, tokenData['refreshToken']);
          }
        }
        return {'success': true, 'message': data['message'] ?? 'OTP terverifikasi'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'OTP salah'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Refresh Token ───
  static Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedRefreshToken = prefs.getString(_keyRefreshToken);

      if (storedRefreshToken == null) return false;

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/refresh'),
        headers: ApiConfig.headers(null),
        body: jsonEncode({'refreshToken': storedRefreshToken}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final tokenData = data['data'];
        if (tokenData != null && tokenData['accessToken'] != null) {
          await prefs.setString(_keyAccessToken, tokenData['accessToken']);
          if (tokenData['refreshToken'] != null) {
            await prefs.setString(_keyRefreshToken, tokenData['refreshToken']);
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ─── Ambil Access Token ───
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  // ─── Cek apakah user sudah login ───
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // ─── Ambil data user tersimpan ───
  static Future<Map<String, String?>> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyUserName),
      'email': prefs.getString(_keyUserEmail),
    };
  }

  // ─── Logout ───
  static Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      try {
        await http.post(
          Uri.parse('${ApiConfig.baseUrl}/auth/logout'),
          headers: ApiConfig.headers(token),
        );
      } catch (e) {
        // Abaikan error jaringan saat logout
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
  }

  // ─── Helper: Request dengan auto-refresh ───
  // Digunakan oleh service lain untuk request yang butuh auth
  static Future<http.Response> authenticatedGet(String url) async {
    var token = await getToken();
    if (token == null) throw Exception('Belum login');

    var response = await http.get(
      Uri.parse(url),
      headers: ApiConfig.headers(token),
    );

    // Jika 401 (expired), coba refresh lalu retry
    if (response.statusCode == 401) {
      final refreshed = await refreshToken();
      if (refreshed) {
        token = await getToken();
        response = await http.get(
          Uri.parse(url),
          headers: ApiConfig.headers(token),
        );
      }
    }

    return response;
  }

  static Future<http.Response> authenticatedPost(String url, {Object? body}) async {
    var token = await getToken();
    if (token == null) throw Exception('Belum login');

    var response = await http.post(
      Uri.parse(url),
      headers: ApiConfig.headers(token),
      body: body != null ? jsonEncode(body) : null,
    );

    if (response.statusCode == 401) {
      final refreshed = await refreshToken();
      if (refreshed) {
        token = await getToken();
        response = await http.post(
          Uri.parse(url),
          headers: ApiConfig.headers(token),
          body: body != null ? jsonEncode(body) : null,
        );
      }
    }

    return response;
  }

  static Future<http.Response> authenticatedPut(String url, {Object? body}) async {
    var token = await getToken();
    if (token == null) throw Exception('Belum login');

    var response = await http.put(
      Uri.parse(url),
      headers: ApiConfig.headers(token),
      body: body != null ? jsonEncode(body) : null,
    );

    if (response.statusCode == 401) {
      final refreshed = await refreshToken();
      if (refreshed) {
        token = await getToken();
        response = await http.put(
          Uri.parse(url),
          headers: ApiConfig.headers(token),
          body: body != null ? jsonEncode(body) : null,
        );
      }
    }

    return response;
  }

  static Future<http.Response> authenticatedDelete(String url) async {
    var token = await getToken();
    if (token == null) throw Exception('Belum login');

    var response = await http.delete(
      Uri.parse(url),
      headers: ApiConfig.headers(token),
    );

    if (response.statusCode == 401) {
      final refreshed = await refreshToken();
      if (refreshed) {
        token = await getToken();
        response = await http.delete(
          Uri.parse(url),
          headers: ApiConfig.headers(token),
        );
      }
    }

    return response;
  }

  static Future<http.Response> authenticatedPatch(String url, {Object? body}) async {
    var token = await getToken();
    if (token == null) throw Exception('Belum login');

    var response = await http.patch(
      Uri.parse(url),
      headers: ApiConfig.headers(token),
      body: body != null ? jsonEncode(body) : null,
    );

    if (response.statusCode == 401) {
      final refreshed = await refreshToken();
      if (refreshed) {
        token = await getToken();
        response = await http.patch(
          Uri.parse(url),
          headers: ApiConfig.headers(token),
          body: body != null ? jsonEncode(body) : null,
        );
      }
    }

    return response;
  }
}
