import 'package:flutter/material.dart';

abstract final class AppColors {  //stores the reusable app's color palette
  static const ocean = Color(0xFF087E8B);
  static const deepOcean = Color(0xFF083D4A);
  static const lagoon = Color(0xFF3FC1C9);
  static const coral = Color(0xFFFF6B4A);
  static const sun = Color(0xFFFFC857);
  static const sand = Color(0xFFFFF4DC);
  static const night = Color(0xFF071D26);
  static const nightSurface = Color(0xFF102E38);
  static const onHero = Color(0xFFFFFFFF);
  static const heroOverlayTop = Color(0x5510202A);
  static const heroOverlayMiddle = Color(0x33000000);
  static const heroOverlayBottom = Color(0xAA061C25);
  static const heroShadow = Color(0x8A000000);
}

abstract final class AppTheme {     //separates light and dark theme data for the app
  static ThemeData get light => _build(
        brightness: Brightness.light,
        scaffold: const Color(0xFFFFFBF3),
        surface: Colors.white,
        text: AppColors.deepOcean,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scaffold: AppColors.night,
        surface: AppColors.nightSurface,
        text: const Color(0xFFF3FBFC),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color scaffold,
    required Color surface,
    required Color text,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.ocean,
      brightness: brightness,
      primary: AppColors.ocean,
      secondary: AppColors.coral,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      fontFamily: 'Trebuchet MS',
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.deepOcean,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.6,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 5,
        color: surface,
        shadowColor: AppColors.deepOcean.withValues(alpha: .18),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: text,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
        ),
        headlineSmall: TextStyle(color: text, fontWeight: FontWeight.w900),
        titleLarge: TextStyle(color: text, fontWeight: FontWeight.w800),
        bodyLarge: TextStyle(color: text.withValues(alpha: .82), height: 1.5),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.coral,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: scheme.primary, side: BorderSide(color: scheme.primary, width: 1.5), padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15), textStyle: const TextStyle(fontWeight: FontWeight.w800), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      ),
chipTheme: ChipThemeData(
  backgroundColor: scheme.primaryContainer,
  side: BorderSide.none,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  labelStyle: TextStyle(
    color: scheme.onPrimaryContainer,
    fontWeight: FontWeight.w700,
  ),
),      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
    );
  }
}
