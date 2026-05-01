import 'dart:convert';
import '../models/user.dart';
import 'api_config.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // ─── Profil saya ───
  static Future<Map<String, dynamic>> getMyProfile() async {
    try {
      // Coba ambil dari local terlebih dahulu
      final localUser = await getLocalProfile();
      
      // Ambil dari API untuk sinkronisasi
      final response = await AuthService.authenticatedGet(
        '${ApiConfig.baseUrl}/users/me',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final user = User.fromJson(data['data']);
        await saveLocalProfile(user); // Update cache local
        return {
          'success': true,
          'user': user,
        };
      } else {
        // Jika API gagal tapi ada data local, kembalikan data local
        if (localUser != null) {
          return {
            'success': true,
            'user': localUser,
          };
        }
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat profil'};
      }
    } catch (e) {
      // Jika error network tapi ada data local, kembalikan data local
      final localUser = await getLocalProfile();
      if (localUser != null) {
        return {
          'success': true,
          'user': localUser,
        };
      }
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Update profil ───
  static Future<Map<String, dynamic>> updateProfile({String? name, String? bio, String? avatarPath}) async {
    try {
      // Simpan ke local terlebih dahulu
      final localUser = await getLocalProfile();
      final updatedUser = User(
        id: localUser?.id ?? 0,
        name: name ?? localUser?.name ?? 'Pengguna Aura Health',
        email: localUser?.email ?? 'pengguna@email.com',
        bio: bio ?? localUser?.bio,
        avatarUrl: avatarPath ?? localUser?.avatarUrl,
      );
      await saveLocalProfile(updatedUser);

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
        // Tetap kembalikan success jika local sudah terupdate (opsional, tapi user minta lokal dulu)
        return {'success': true, 'message': 'Profil disimpan secara lokal'};
      }
    } catch (e) {
      // Jika error network, kita anggap success karena sudah tersimpan di local
      return {'success': true, 'message': 'Profil disimpan secara lokal (offline)'};
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

  // ─── Local Storage ───
  static const String _profileKey = 'user_profile';

  static Future<void> saveLocalProfile(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(user.toJson()));
  }

  static Future<User?> getLocalProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileStr = prefs.getString(_profileKey);
    if (profileStr != null) {
      return User.fromJson(jsonDecode(profileStr));
    }
    return null;
  }
}
