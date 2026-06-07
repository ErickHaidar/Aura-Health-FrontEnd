import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import 'api_config.dart';
import 'auth_service.dart';

class CommunityService {
  // ─── Feed semua post (publik) ───
  static Future<Map<String, dynamic>> getPosts({int page = 1, int limit = 10}) async {
    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/posts?page=$page&limit=$limit'),
        headers: ApiConfig.headers(token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List rawList = data['data'] is List ? data['data'] : (data['data']?['posts'] ?? []);
        final posts = rawList.map((json) => Post.fromJson(json)).toList();
        return {'success': true, 'posts': posts};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat post'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Detail post ───
  static Future<Map<String, dynamic>> getPostDetail(String id) async {
    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/posts/$id'),
        headers: ApiConfig.headers(token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'post': Post.fromJson(data['data'])};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Post tidak ditemukan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Buat post (perlu auth, form-data) ───
  static Future<Map<String, dynamic>> createPost(String content, {String? imagePath, bool isAnonymous = false}) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return {'success': false, 'message': 'Belum login'};

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/posts'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['content'] = content;
      if (isAnonymous) request.fields['isAnonymous'] = 'true';

      if (imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'Post dibuat'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal membuat post'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Hapus post ───
  static Future<Map<String, dynamic>> deletePost(String id) async {
    try {
      final response = await AuthService.authenticatedDelete(
        '${ApiConfig.baseUrl}/posts/$id',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'Post dihapus'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menghapus post'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Like / Unlike post ───
  static Future<Map<String, dynamic>> toggleLike(String postId) async {
    try {
      final response = await AuthService.authenticatedPost(
        '${ApiConfig.baseUrl}/posts/$postId/like',
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'Berhasil'};
      }
      return {'success': false, 'message': data['message'] ?? 'Gagal'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Ambil komentar post ───
  static Future<Map<String, dynamic>> getComments(String postId, {int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/posts/$postId/comments?page=$page&limit=$limit'),
        headers: ApiConfig.headers(null),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List rawList = data['data'] is List ? data['data'] : (data['data']?['comments'] ?? []);
        final comments = rawList.map((json) => Comment.fromJson(json)).toList();
        return {'success': true, 'comments': comments};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat komentar'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Tambah komentar ───
  static Future<Map<String, dynamic>> addComment(String postId, String comment) async {
    try {
      final response = await AuthService.authenticatedPost(
        '${ApiConfig.baseUrl}/posts/$postId/comments',
        body: {'comment': comment},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': data['message'] ?? 'Komentar ditambahkan'};
      }
      return {'success': false, 'message': data['message'] ?? 'Gagal menambah komentar'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Hapus komentar ───
  static Future<Map<String, dynamic>> deleteComment(String postId, String commentId) async {
    try {
      final response = await AuthService.authenticatedDelete(
        '${ApiConfig.baseUrl}/posts/$postId/comments/$commentId',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'Komentar dihapus'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menghapus komentar'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Update post ───
  static Future<Map<String, dynamic>> updatePost(String id, {String? content, String? imagePath}) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return {'success': false, 'message': 'Belum login'};

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConfig.baseUrl}/posts/$id'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      if (content != null) request.fields['content'] = content;
      if (imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'post': data['data'] != null ? Post.fromJson(data['data']) : null,
          'message': data['message'] ?? 'Post diperbarui',
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memperbarui post'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Like / Unlike komentar ───
  static Future<Map<String, dynamic>> toggleCommentLike(String postId, String commentId) async {
    try {
      final response = await AuthService.authenticatedPost(
        '${ApiConfig.baseUrl}/posts/$postId/comments/$commentId/like',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'liked': data['data']?['liked'] ?? data['liked'] ?? false,
          'likesCount': data['data']?['likesCount'] ?? 0,
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal like/unlike komentar'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }
}
