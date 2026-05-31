import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color cardBg = Color(0xFF1A1A2E);
  static const Color glassBg = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color accent = Color(0xFF6C63FF);
  static const Color accentSecondary = Color(0xFFFF6584);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF666666);

  static const Map<String, Color> typeColors = {
    'fire': Color(0xFFFF6B35),
    'water': Color(0xFF4FC3F7),
    'grass': Color(0xFF66BB6A),
    'electric': Color(0xFFFFD54F),
    'psychic': Color(0xFFEC407A),
    'ice': Color(0xFF80DEEA),
    'dragon': Color(0xFF7E57C2),
    'dark': Color(0xFF5D4037),
    'fairy': Color(0xFFF48FB1),
    'fighting': Color(0xFFEF5350),
    'poison': Color(0xFFAB47BC),
    'ground': Color(0xFFD4A574),
    'flying': Color(0xFF90CAF9),
    'bug': Color(0xFF9CCC65),
    'rock': Color(0xFFBDBDBD),
    'ghost': Color(0xFF7B1FA2),
    'steel': Color(0xFF90A4AE),
    'normal': Color(0xFF757575),
  };

  static const Map<String, Color> roleColors = {
    'Tank': Color(0xFF1565C0),
    'Speedster': Color(0xFFFF8F00),
    'Glass Cannon': Color(0xFFB71C1C),
    'Balanced': Color(0xFF2E7D32),
  };

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentSecondary,
        surface: surface,
        background: background,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textMuted),
      ),
    );
  }
}
