import 'package:flutter/material.dart';

/// Colores, tamaños y formas del diseño aprobado.
class AppTheme {
  AppTheme._();
  static const naranja = Color(0xFFF36F21);

  static ThemeData crear(Brightness brillo) {
    final oscuro = brillo == Brightness.dark;
    final fondo = oscuro ? const Color(0xFF111419) : const Color(0xFFF6F7FA);
    final superficie = oscuro ? const Color(0xFF1C222A) : Colors.white;
    final texto = oscuro ? const Color(0xFFF8FAFC) : const Color(0xFF161D27);
    final colores = ColorScheme.fromSeed(
      seedColor: naranja,
      brightness: brillo,
      surface: superficie,
      primary: naranja,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brillo,
      colorScheme: colores,
    );
    return base.copyWith(
      scaffoldBackgroundColor: fondo,
      textTheme: base.textTheme
          .apply(bodyColor: texto, displayColor: texto)
          .copyWith(
            headlineMedium: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: texto,
            ),
            titleLarge: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: texto,
            ),
            titleMedium: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: texto,
            ),
            bodyLarge: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: texto,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: texto,
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: fondo,
        foregroundColor: texto,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: texto,
        ),
      ),
      cardTheme: CardThemeData(
        color: superficie,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23),
          side: BorderSide(
            color: oscuro ? const Color(0xFF303B47) : const Color(0xFFE3E7EE),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: superficie,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 19,
        ),
        hintStyle: TextStyle(
          color: oscuro ? const Color(0xFFACB7C4) : const Color(0xFF697586),
          fontSize: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: oscuro ? const Color(0xFF37414C) : const Color(0xFFDCE1E8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: naranja, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: naranja,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 54),
          textStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: superficie,
        indicatorColor: naranja.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
