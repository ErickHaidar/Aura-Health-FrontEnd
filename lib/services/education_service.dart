import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/education.dart';
import 'api_config.dart';
import '../data/static_education_data.dart';

class EducationService {
  // ─── Kategori edukasi ───
  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/education/categories'),
        headers: ApiConfig.headers(null),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List rawList = data['data'] is List ? data['data'] : [];
        final categories = rawList.map((json) => EducationCategory.fromJson(json)).toList();
        return {'success': true, 'categories': categories};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat kategori'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Konten per kategori ───
  static Future<Map<String, dynamic>> getContentByCategory(String category) async {
    // --- Static Fallback Content ---
    final lowerCategory = category.toLowerCase();
    if (StaticEducationData.categoryContent.containsKey(lowerCategory)) {
      return {
        'success': true,
        'contents': StaticEducationData.categoryContent[lowerCategory]
      };
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/education/category/$category'),
        headers: ApiConfig.headers(null),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List rawList = data['data'] is List ? data['data'] : [];
        final contents = rawList.map((json) => EducationContent.fromJson(json)).toList();
        return {'success': true, 'contents': contents};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal memuat konten'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Detail konten edukasi ───
  static Future<Map<String, dynamic>> getContentDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/education/$id'),
        headers: ApiConfig.headers(null),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'content': EducationContent.fromJson(data['data']),
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Konten tidak ditemukan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  // ─── Cached categories (alias untuk getCategories) ───
  static Future<Map<String, dynamic>> getCachedCategories() => getCategories();

  // ─── Cached contents per category (alias untuk getContentByCategory) ───
  static Future<Map<String, dynamic>> getCachedContents(String category) =>
      getContentByCategory(category);
}
