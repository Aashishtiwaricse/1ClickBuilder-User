import 'package:flutter/material.dart';

ThemeData AmzTheme() {
  return ThemeData(
    useMaterial3: false,

    // 🧱 Amazon background
    scaffoldBackgroundColor: const Color(0xFFF3F3F3),

    colorScheme: const ColorScheme.light(
      // Amazon logic: dark primary
      primary: Color(0xFF2B2B2B), // text + icons
      secondary: Color(0xFFF28BA8), // accent only
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),

    // 🧭 AppBar (Amazon header)
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: false,
      iconTheme: IconThemeData(color: Color(0xFF2B2B2B)),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2B2B2B),
      ),
    ),

    // 📝 Amazon text hierarchy
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF111111),
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F1111),
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFFC24A6A), // price
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        color: Color(0xFF333333),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(0xFF565959),
      ),
    ),

    // 🟡 Amazon button logic (flat)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF28BA8),
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // Amazon radius
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // 🔲 Outline button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2B2B2B),
        side: const BorderSide(color: Color(0xFF2B2B2B)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),

    // 🧱 Amazon cards
    // cardTheme: CardTheme(
    //   color: Colors.white,
    //   elevation: 0.8,
    //   shadowColor: Colors.black12,
    //   margin: const EdgeInsets.all(6),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(8),
    //   ),
    // ),

    // 🧭 Bottom nav
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF2B2B2B),
      unselectedItemColor: Color(0xFF9A9A9A),
      selectedLabelStyle: TextStyle(fontSize: 11),
      unselectedLabelStyle: TextStyle(fontSize: 11),
      elevation: 8,
    ),

    // 🔹 Divider
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
    ),
  );
}
