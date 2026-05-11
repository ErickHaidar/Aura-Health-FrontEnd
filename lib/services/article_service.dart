import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import 'api_config.dart';
import 'auth_service.dart';

class ArticleService {
  // ─── List artikel ───
  static Future<Map<String, dynamic>> getArticles({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    try {
      var url = '${ApiConfig.baseUrl}/articles?page=$page&limit=$limit';
      if (category != null && category.isNotEmpty) url += '&category=$category';
      if (search != null && search.isNotEmpty) url += '&search=${Uri.encodeComponent(search)}';

      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConfig.headers(token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List rawList = data['data'] is List ? data['data'] : (data['data']?['articles'] ?? []);
        final articles = rawList.map((json) => Article.fromJson(json)).toList();
        return {
          'success': true,
          'articles': articles,
          'pagination': data['meta'] ?? data['pagination'],
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat artikel'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Daftar kategori ───
  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/articles/categories'),
        headers: ApiConfig.headers(null),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List categories = data['data'] is List ? data['data'] : [];
        return {'success': true, 'categories': categories};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat kategori'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Detail artikel ───
  static Future<Map<String, dynamic>> getArticleDetail(String id) async {
    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/articles/$id'),
        headers: ApiConfig.headers(token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'article': Article.fromJson(data['data']),
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Artikel tidak ditemukan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Like / unlike artikel ───
  static Future<Map<String, dynamic>> likeArticle(String id) async {
    try {
      final response = await AuthService.authenticatedPost(
        '${ApiConfig.baseUrl}/articles/$id/like',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final articleData = data['data']?['article'] ?? data['data'];
        return {
          'success': true,
          'liked': data['data']?['liked'] ?? data['liked'] ?? false,
          'article': articleData != null ? Article.fromJson(articleData) : null,
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menyukai artikel'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }
}
