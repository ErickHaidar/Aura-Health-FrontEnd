import 'dart:convert';
import '../models/app_notification.dart';
import 'api_config.dart';
import 'auth_service.dart';

class NotificationService {
  // ─── Ambil semua notifikasi ───
  static Future<Map<String, dynamic>> getNotifications() async {
    try {
      final response = await AuthService.authenticatedGet(
        '${ApiConfig.baseUrl}/notifications',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List rawList = data['data'] is List ? data['data'] : [];
        final notifications = rawList.map((json) => AppNotification.fromJson(json)).toList();
        return {'success': true, 'notifications': notifications};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat notifikasi'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Tandai semua dibaca ───
  static Future<Map<String, dynamic>> markAllRead() async {
    try {
      final response = await AuthService.authenticatedPatch(
        '${ApiConfig.baseUrl}/notifications/read-all',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'Semua notifikasi dibaca'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menandai notifikasi'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Tandai satu dibaca ───
  static Future<Map<String, dynamic>> markAsRead(int id) async {
    try {
      final response = await AuthService.authenticatedPatch(
        '${ApiConfig.baseUrl}/notifications/$id/read',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'Notifikasi dibaca'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menandai notifikasi'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }
}
