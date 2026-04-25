import 'package:flutter/material.dart';
import 'dart:async';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.medical_services,
                size: 64,
                color: Colors.white,
              ),
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
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textDark),
            ),
          ],
        ),
      ),
    );
  }
}
