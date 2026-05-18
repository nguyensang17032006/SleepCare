import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color bgColor = Color(0xFF11172D);
  static const Color cardColor = Color(0xFF1E2648);
  static const Color cardLightColor = Color(0xFF2B3663);
  static const Color primaryColor = Color(0xFFBCA6FF);
  static const Color secondaryColor = Color(0xFF8BA6FF);
  
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF8A95B6);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
        background: bgColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(color: textLight, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(color: textLight, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.poppins(color: textLight),
        bodyMedium: GoogleFonts.poppins(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: textLight),
        iconTheme: const IconThemeData(color: textLight),
      ),
    );
  }

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0C132B), Color(0xFF1A2346), Color(0xFF0C132B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFFAFA0FB), Color(0xFF8E7CE7)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
