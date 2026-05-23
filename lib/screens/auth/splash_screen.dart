import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Tampilkan splash minimal 2 detik
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final token = await AuthService.getToken();

    // Tidak ada token sama sekali → langsung ke login
    if (token == null) {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // Ada token → coba validasi ke server (ambil profil)
    // Jika 401, coba refresh. Jika refresh gagal → login.
    try {
      final result = await UserService.getMyProfile();
      if (!mounted) return;

      if (result['success'] == true) {
        // Token valid, profil tersimpan di cache → masuk app
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        // Profil gagal (token mungkin expired) → coba refresh
        final refreshed = await AuthService.refreshToken();
        if (!mounted) return;
        if (refreshed) {
          // Refresh berhasil → masuk app
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          // Refresh gagal → paksa login ulang
          await AuthService.logout();
          if (mounted) Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (_) {
      if (!mounted) return;
      // Network error → kalau ada cache local, tetap masuk
      final localUser = await UserService.getLocalProfile();
      if (!mounted) return;
      if (localUser != null) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_aura.png',
              height: 160,
            ),
            const SizedBox(height: 24),
            Text(
              'Aura Health',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppTheme.primaryColor,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bebas TBC, Hidup Lebih Sehat',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              color: AppTheme.primaryColor,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
