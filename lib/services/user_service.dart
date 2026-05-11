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
    final localUser = await getLocalProfile();

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
        // Refresh profil lengkap dari server (termasuk avatarUrl yang benar)
        final freshResult = await getMyProfile();
        return {
          'success': true,
          'message': data['message'] ?? 'Profil diperbarui',
          'user': freshResult['user'],
        };
      } else {
        // Fallback: update lokal saja tanpa avatarUrl baru
        if (localUser != null) {
          final updatedUser = User(
            id: localUser.id,
            name: name ?? localUser.name,
            email: localUser.email,
            bio: bio ?? localUser.bio,
            avatarUrl: localUser.avatarUrl, // jaga avatarUrl yang sudah ada
          );
          await saveLocalProfile(updatedUser);
          return {
            'success': true,
            'message': 'Profil disimpan secara lokal',
            'user': updatedUser,
          };
        }
        return {'success': false, 'message': data['message'] ?? 'Gagal memperbarui profil'};
      }
    } catch (e) {
      if (localUser != null) {
        final updatedUser = User(
          id: localUser.id,
          name: name ?? localUser.name,
          email: localUser.email,
          bio: bio ?? localUser.bio,
          avatarUrl: localUser.avatarUrl,
        );
        await saveLocalProfile(updatedUser);
        return {
          'success': true,
          'message': 'Profil disimpan secara lokal (offline)',
          'user': updatedUser,
        };
      }
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
        // Simpan avatarUrl dari server ke local cache
        final avatarUrl =
            data['data']?['avatarUrl'] ??
            data['data']?['avatar_url'] ??
            data['avatarUrl'];
        if (avatarUrl != null) {
          final localUser = await getLocalProfile();
          if (localUser != null) {
            await saveLocalProfile(User(
              id: localUser.id,
              name: localUser.name,
              email: localUser.email,
              bio: localUser.bio,
              avatarUrl: avatarUrl,
            ));
          }
        }
        return {
          'success': true,
          'message': data['message'] ?? 'Avatar diperbarui',
          'avatarUrl': avatarUrl,
        };
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
    final savedUser = await AuthService.getSavedUser();
    final name = savedUser['name'];
    final email = savedUser['email'];
    if (name != null || email != null) {
      return User(
        id: '0',
        name: name ?? 'Pengguna Aura Health',
        email: email ?? '',
      );
    }
    return null;
  }
}
