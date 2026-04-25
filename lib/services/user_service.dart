import 'dart:convert';
import '../models/user.dart';
import 'api_config.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;

class UserService {
  // ─── Profil saya ───
  static Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await AuthService.authenticatedGet(
        '${ApiConfig.baseUrl}/users/me',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'user': User.fromJson(data['data']),
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat profil'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Update profil ───
  static Future<Map<String, dynamic>> updateProfile({String? name, String? bio}) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (bio != null) body['bio'] = bio;

      final response = await AuthService.authenticatedPut(
        '${ApiConfig.baseUrl}/users/me',
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'Profil diperbarui'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal update profil'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Upload avatar ───
  static Future<Map<String, dynamic>> uploadAvatar(String filePath) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return {'success': false, 'message': 'Belum login'};

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/users/me/avatar'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('avatar', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'Avatar diperbarui'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal upload avatar'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Profil publik user lain ───
  static Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final response = await AuthService.authenticatedGet(
        '${ApiConfig.baseUrl}/users/$userId',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'user': User.fromJson(data['data']),
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat profil user'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }
}
