import 'package:flutter/material.dart';
import 'package:rate_my_anime/services/theme_services/dark_theme.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeService {
  static void switchTheme(BuildContext context) =>
      ThemeProvider.controllerOf(context).nextTheme();

  static bool isDarkMode(BuildContext context) =>
      ThemeProvider.controllerOf(context).currentThemeId == DarkTheme.id;

  static BoxShadow boxShadow(BuildContext context) =>
      ThemeService.isDarkMode(context)
          ? const BoxShadow(
              color: Color.fromARGB(207, 43, 39, 39),
              offset: Offset(0, 1),
              blurRadius: 1)
          : const BoxShadow(
              color: Color.fromARGB(34, 65, 69, 73),
              offset: Offset(0, 1),
              blurRadius: 1);

  static const Color primary = Color(0xFF2C70F4);
  static const Color secondary = Color(0xFF6C7279);
  static const Color danger = Color(0xFFCB444A);
  static const Color success = Color(0xFF408458);
  static const Color warning = Color(0xFFF7C244);
  static const Color light = Color(0xFFF8F9FA);
  static const Color dark = Color.fromARGB(255, 10, 10, 10);
}
