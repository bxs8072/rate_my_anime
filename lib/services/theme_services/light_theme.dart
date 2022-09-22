import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';

class LightTheme {
  static const String id = "light";

  static const Color appBarBgColor = Color(0xFFF6F6F7);
  static const Color bottomNavBarBgColor = Color(0xFFF6F6F7);
  static const Color cardBgColor = Color(0xFFF6F6F7);

  static const Color scaffoldBgColor = Color(0xFFFFFFFF);

  static const Color primaryTextColor = Color(0xFF262626);
  static const Color primaryIconColor = Color(0xFF262626);

  static const Color secondaryTextColor = Color(0xFF7C7C7C);
  static const Color secondaryIconColor = Color(0xFF7C7C7C);

  static ThemeData theme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarBgColor,
      foregroundColor: ThemeService.dark,
      elevation: 0,
    ),
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: ThemeService.dark,
      labelColor: ThemeService.primary,
    ),
    scaffoldBackgroundColor: scaffoldBgColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bottomNavBarBgColor,
      elevation: 0.0,
      selectedItemColor: ThemeService.primary,
      unselectedItemColor: secondaryIconColor,
      type: BottomNavigationBarType.fixed,
    ),
    cardColor: cardBgColor,
    cardTheme: const CardTheme(
      color: cardBgColor,
      elevation: 6.0,
    ),
    iconTheme: const IconThemeData(
      color: primaryIconColor,
    ),
    primaryIconTheme: const IconThemeData(
      color: secondaryIconColor,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: cardBgColor,
      elevation: 0.0,
    ),
    textTheme: TextTheme(
      bodyText1: GoogleFonts.lato(color: primaryTextColor),
      bodyText2: GoogleFonts.lato(color: primaryTextColor),
      subtitle1: GoogleFonts.lato(color: primaryTextColor),
      subtitle2: GoogleFonts.lato(color: primaryTextColor),
      caption: GoogleFonts.lato(
        color: secondaryTextColor,
      ),
      button: GoogleFonts.lato(
        color: primaryTextColor,
      ),
    ),
  );
}
