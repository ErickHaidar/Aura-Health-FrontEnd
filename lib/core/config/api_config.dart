import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    // Mengambil URL dari .env, jika tidak ada pakai default
    final envUrl = dotenv.get(
      'API_URL',
      fallback: 'https://aura-health-backend-mz7r.onrender.com',
    );

    return '$envUrl/api';
  }

  static String get socketUrl {
    return dotenv.get(
      'API_URL',
      fallback: 'https://aura-health-backend-mz7r.onrender.com',
    );
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
