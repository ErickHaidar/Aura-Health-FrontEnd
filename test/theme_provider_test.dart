import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurahealth/providers/theme_provider.dart';

void main() {
  group('ThemeProvider Tests', () {
    test('Initial theme should be light', () {
      final themeProvider = ThemeProvider();
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('toggleTheme should switch light to dark', () {
      final themeProvider = ThemeProvider();
      themeProvider.toggleTheme(true);
      expect(themeProvider.themeMode, ThemeMode.dark);
    });

    test('toggleTheme should switch dark to light', () {
      final themeProvider = ThemeProvider();
      themeProvider.toggleTheme(true); // to dark
      themeProvider.toggleTheme(false); // to light
      expect(themeProvider.themeMode, ThemeMode.light);
    });
  });
}
