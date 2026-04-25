import 'dart:convert';
import '../models/chat_message.dart';
import 'api_config.dart';
import 'auth_service.dart';

class ChatService {
  // ─── Kirim pesan ke AI ───
  static Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final response = await AuthService.authenticatedPost(
        '${ApiConfig.baseUrl}/chat',
        body: {'message': message},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['data']?['response'] ?? data['data']?['message'] ?? '',
        };
      } else if (response.statusCode == 429) {
        return {'success': false, 'message': 'Terlalu banyak pesan. Coba lagi nanti.'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal mengirim pesan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Riwayat chat ───
  static Future<Map<String, dynamic>> getHistory({int page = 1, int limit = 20}) async {
    try {
      final response = await AuthService.authenticatedGet(
        '${ApiConfig.baseUrl}/chat/history?page=$page&limit=$limit',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List rawList = data['data'] is List ? data['data'] : (data['data']?['messages'] ?? []);
        final messages = rawList.map((json) => ChatMessage.fromJson(json)).toList();
        return {'success': true, 'messages': messages};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat riwayat'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Hapus riwayat chat ───
  static Future<Map<String, dynamic>> clearHistory() async {
    try {
      final response = await AuthService.authenticatedDelete(
        '${ApiConfig.baseUrl}/chat/history',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'Riwayat dihapus'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menghapus riwayat'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }
}
