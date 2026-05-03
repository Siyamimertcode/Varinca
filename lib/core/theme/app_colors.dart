import 'package:flutter/material.dart';

/// Varınca Renk Paleti - Geliştirilmiş
class AppColors {
  AppColors._();

  // Ana Renkler
  static const Color primaryRed = Color(0xFFEA2630);
  static const Color brightRed = Color(0xFFF9474D);
  static const Color deepRed = Color(0xFFD91E28);

  // Arka Plan Renkleri
  static const Color lightPink = Color(0xFFFDF7F7);
  static const Color softPink = Color(0xFFFCE5E6);
  static const Color pastelPink = Color(0xFFEC9B9D);
  static const Color background = Color(0xFFFAFAFA);
  static const Color appBarBackground = Color(0xFFFFFFFF); // Beyaz

  // Nötr Renkler
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF1A1A1A);
  static const Color mediumText = Color(0xFF4A4A4A);
  static const Color greyText = Color(0xFF7A7A7A);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color border = Color(0xFFE8E8E8);

  // Durum Renkleri
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gölge Renkleri
  static Color shadowLight = Colors.black.withValues(alpha: 0.04);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.08);
  static Color shadowDark = Colors.black.withValues(alpha: 0.12);
  static Color primaryShadow = primaryRed.withValues(alpha: 0.25);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, brightRed],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [white, lightPink],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, Color(0xFFFFFAFA)],
  );
}

/// Uygulama genelinde kullanılacak dekorasyon stilleri
class AppDecorations {
  AppDecorations._();

  // Kartlar için yumuşak gölge
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  // Kartlar için orta gölge
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: AppColors.shadowMedium,
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // Vurgulu kartlar için gölge
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: AppColors.shadowDark,
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  // Primary butonlar için gölge
  static List<BoxShadow> get primaryShadow => [
    BoxShadow(
      color: AppColors.primaryShadow,
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // Kart dekorasyonu
  static BoxDecoration get card => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: softShadow,
  );

  // Elevated kart dekorasyonu
  static BoxDecoration get elevatedCard => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: mediumShadow,
  );

  // Input field dekorasyonu
  static BoxDecoration get inputField => BoxDecoration(
    color: AppColors.lightGrey,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.border, width: 1),
  );

  // Seçili input dekorasyonu
  static BoxDecoration get inputFieldFocused => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.primaryRed, width: 1.5),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryRed.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
