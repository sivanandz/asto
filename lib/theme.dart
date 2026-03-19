import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF5A805B),
      scaffoldBackgroundColor: const Color(0xFF09090B),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF5A805B),
        onPrimary: Color(0xFF133819),
        primaryContainer: Color(0xFF123719),
        onPrimaryContainer: Color(0xFF79A27A),
        secondary: Color(0xFFBACBB7),
        onSecondary: Color(0xFF253426),
        secondaryContainer: Color(0xFF3B4B3B),
        onSecondaryContainer: Color(0xFFA9BAA6),
        tertiary: Color(0xFFA8CAEF),
        onTertiary: Color(0xFF093351),
        tertiaryContainer: Color(0xFF083250),
        onTertiaryContainer: Color(0xFF799BBE),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        background: Color(0xFF121411),
        onBackground: Color(0xFFE2E3DE),
        surface: Color(0xFF09090B),
        onSurface: Color(0xFFFAFAFA),
        surfaceVariant: Color(0xFF333532),
        onSurfaceVariant: Color(0xFFC2C8BE),
        outline: Color(0xFF8C9389),
        outlineVariant: Color(0xFF424941),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.publicSans(fontWeight: FontWeight.w900, color: const Color(0xFFFAFAFA)),
        displayMedium: GoogleFonts.publicSans(fontWeight: FontWeight.w900, color: const Color(0xFFFAFAFA)),
        displaySmall: GoogleFonts.publicSans(fontWeight: FontWeight.w900, color: const Color(0xFFFAFAFA)),
        headlineLarge: GoogleFonts.publicSans(fontWeight: FontWeight.w900, color: const Color(0xFFFAFAFA)),
        headlineMedium: GoogleFonts.publicSans(fontWeight: FontWeight.w900, color: const Color(0xFFFAFAFA)),
        headlineSmall: GoogleFonts.publicSans(fontWeight: FontWeight.w700, color: const Color(0xFFFAFAFA)),
        titleLarge: GoogleFonts.publicSans(fontWeight: FontWeight.w700, color: const Color(0xFFFAFAFA)),
        titleMedium: GoogleFonts.publicSans(fontWeight: FontWeight.w700, color: const Color(0xFFFAFAFA)),
        titleSmall: GoogleFonts.publicSans(fontWeight: FontWeight.w700, color: const Color(0xFFFAFAFA)),
        bodyLarge: GoogleFonts.manrope(fontWeight: FontWeight.w400, color: const Color(0xFFFAFAFA)),
        bodyMedium: GoogleFonts.manrope(fontWeight: FontWeight.w400, color: const Color(0xFFFAFAFA)),
        bodySmall: GoogleFonts.manrope(fontWeight: FontWeight.w400, color: const Color(0xFFA1A1AA)),
        labelLarge: GoogleFonts.publicSans(fontWeight: FontWeight.w700, color: const Color(0xFFA1A1AA)),
        labelMedium: GoogleFonts.publicSans(fontWeight: FontWeight.w700, color: const Color(0xFFA1A1AA)),
        labelSmall: GoogleFonts.publicSans(fontWeight: FontWeight.w700, color: const Color(0xFFA1A1AA)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF09090B),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0xFF5A805B)),
        titleTextStyle: TextStyle(
          fontFamily: 'Public Sans',
          fontWeight: FontWeight.w900,
          fontSize: 20,
          letterSpacing: -0.5,
          color: Color(0xFFFAFAFA),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF09090B),
        selectedItemColor: Color(0xFF5A805B),
        unselectedItemColor: Color(0xFFA1A1AA),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0C0F0C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Color(0xFF27272A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Color(0xFF27272A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Color(0xFF5A805B), width: 2),
        ),
        labelStyle: GoogleFonts.publicSans(fontWeight: FontWeight.w600, color: const Color(0xFFA1A1AA), fontSize: 12),
        hintStyle: GoogleFonts.manrope(fontWeight: FontWeight.w400, color: const Color(0xFFA1A1AA)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A805B),
          foregroundColor: const Color(0xFF09090B),
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFAFAFA),
          side: const BorderSide(color: Color(0xFF27272A)),
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF27272A),
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Common Colors
  static const Color surfaceContainer = Color(0xFF1E201D);
  static const Color surfaceContainerLow = Color(0xFF1A1C19);
  static const Color surfaceContainerLowest = Color(0xFF0C0F0C);
  static const Color borderColor = Color(0xFF27272A);
  static const Color textMuted = Color(0xFFA1A1AA);
  static const Color textMain = Color(0xFFFAFAFA);
  static const Color primary = Color(0xFF5A805B);
  static const Color tertiary = Color(0xFFA8CAEF);
  static const Color error = Color(0xFFEF4444);
  static const Color tertiaryContainer = Color(0xFF083250);
  static const Color outlineVariant = Color(0xFF424941);
  static const Color onSurfaceVariant = Color(0xFFC2C8BE);
  static const Color onPrimary = Color(0xFF133819);
}
