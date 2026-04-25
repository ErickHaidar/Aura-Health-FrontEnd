import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import 'api_config.dart';

class ArticleService {
  // ─── List artikel (publik, tanpa auth) ───
  static Future<Map<String, dynamic>> getArticles({int page = 1, int limit = 10, String? category}) async {
    try {
      var url = '${ApiConfig.baseUrl}/articles?page=$page&limit=$limit';
      if (category != null) url += '&category=$category';

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConfig.headers(null),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List rawList = data['data'] is List ? data['data'] : (data['data']?['articles'] ?? []);
        final articles = rawList.map((json) => Article.fromJson(json)).toList();
        return {'success': true, 'articles': articles};
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
  static Future<Map<String, dynamic>> getArticleDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/articles/$id'),
        headers: ApiConfig.headers(null),
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
}
