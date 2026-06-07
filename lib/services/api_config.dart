import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    // Mengambil URL dari .env, jika tidak ada pakai default
    final envUrl = dotenv.get(
      'API_URL',
      fallback: 'https://aura-health-backend-mz7r.onrender.com',
    );
    
    if (kIsWeb) return 'http://localhost:3000/api';
    return '$envUrl/api';
  }

  // Helper untuk Headers
  static Map<String, String> headers(String? token) {
    Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Bypass halaman interstitial ngrok free
      'ngrok-skip-browser-warning': 'true',
    };
    if (token != null) {
      defaultHeaders['Authorization'] = 'Bearer $token';
    }
    return defaultHeaders;
  }
}
