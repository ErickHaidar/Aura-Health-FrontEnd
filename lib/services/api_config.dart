import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  // Jika menggunakan Emulator Android, localhost harus diganti jadi 10.0.2.2
  // Jika mengetes di HP fisik via WiFi, ganti dengan IP Address laptop (contoh: 192.168.1.10)
  // Ngrok URL — ganti kalau ngrok restart (URL berubah)
  static const _ngrokUrl = 'https://tobie-unpensioning-melia.ngrok-free.dev';

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    // Pakai ngrok untuk HP fisik (bypass WiFi isolation)
    return '$_ngrokUrl/api';
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
